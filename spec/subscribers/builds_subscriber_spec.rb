# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildsSubscriber do
  subject { described_class.new }
  with_events

  let(:project_build) { create(:build, :with_project) }

  let(:image) { project_build.project.images.first }
  let(:image_step) { project_build.steps.for_images.first }

  let(:pipeline) { project_build.project.pipelines.first }
  let(:pipeline_step) { project_build.steps.for_pipelines.first }

  describe '#build_created' do
    before { project_build }

    it { expect(Runner::BuildImageJob).to have_enqueued_sidekiq_job(project_build.id, image.id) }
    it { expect(project_build.started_at).not_to be_nil }
  end

  describe '#build_done' do
    before do
      Timecop.freeze(Time.local(1990))
      subject.build_done(project_build)
    end
    it 'sets finished_at to current time' do
      expect(project_build.finished_at).to eq(Time.local(1990))
    end
    after { Timecop.return }
  end

  describe '#build_failed' do
    before do
      Timecop.freeze(Time.local(1990))
      subject.build_failed(project_build)
    end
    it 'sets finished_at' do
      expect(project_build.finished_at).to eq(Time.local(1990))
    end
    after { Timecop.return }
  end

  describe 'sidekiq batch callbacks' do
    let(:failures) { 0 }
    let(:build_status) { :running }
    let(:project_build) { create(:build, :with_project, :is_running, steps: 5, status: build_status) }
    let(:status) { double('Sidekiq::Batch::Status', failures: failures) }
    let(:options) { { 'build_id' => project_build.id } }

    describe '#sidekiq_build_complete' do
      before do
        image_step
        subject.sidekiq_build_complete(status, options)
        project_build.reload
      end

      context 'any sidekiq job is failed' do
        let(:failures) { 5 }

        it { expect(project_build).to be_failed }
        it { expect(Runner::PipelineJob).not_to have_enqueued_sidekiq_job(project_build.id, pipeline.id) }
      end

      context 'build have failed status' do
        let(:build_status) { :failed }

        it { expect(project_build).to be_failed }
        it { expect(Runner::PipelineJob).not_to have_enqueued_sidekiq_job(project_build.id, pipeline.id) }
      end

      context 'build have failed step' do
        let!(:image_step) do
          project_build.steps.for_images.first.tap(&:failed!)
        end

        it { expect(project_build).to be_failed }
        it { expect(Runner::PipelineJob).not_to have_enqueued_sidekiq_job(project_build.id, pipeline.id) }
      end

      context 'success' do
        it { expect(project_build).not_to be_failed }
        it { expect(Runner::PipelineJob).to have_enqueued_sidekiq_job(project_build.id, pipeline.id) }
      end
    end

    describe '#sidekiq_pipelines_complete' do
      before do
        pipeline_step
        subject.sidekiq_pipelines_complete(status, options)
        project_build.reload
      end

      describe 'without deploys' do
        context 'any sidekiq job is failed' do
          let(:failures) { 5 }

          it { expect(project_build).to be_failed }
          it { expect(Runner::DeployJob).not_to have_enqueued_sidekiq_job }
        end

        context 'build have failed status' do
          let(:build_status) { :failed }

          it { expect(project_build).to be_failed }
          it { expect(Runner::DeployJob).not_to have_enqueued_sidekiq_job }
        end

        context 'build have failed step' do
          let!(:pipeline_step) do
            project_build.steps.for_pipelines.first.tap(&:failed!)
          end

          it { expect(project_build).to be_failed }
          it { expect(Runner::DeployJob).not_to have_enqueued_sidekiq_job}
        end

        context 'success' do
          it { expect(project_build).to be_done }
        end
      end

      context 'with deploys' do
        pending
      end
    end

    describe '#sidekiq_deploy_complete' do
      pending
    end
  end
end
