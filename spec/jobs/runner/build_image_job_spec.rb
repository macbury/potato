# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runner::BuildImageJob do
  let(:build) { create(:build, :with_project, :is_running, steps: 10) }
  let(:build_image) { build.project.images.first }
  let(:image_step) { build.steps.for_images.first }

  it { is_expected.to be_processed_in :builds }
  it { is_expected.to be_retryable 0 }
  it { is_expected.to save_backtrace }

  describe '#perform' do
    let(:job) { described_class.new }
    subject { job.perform(build.id, build_image.id) }
    let(:image) { double('Docker::Image', id: 'yolo') }
    let(:batch) { double('Sidekiq::Batch') }

    context 'success' do
      let(:first_log) { 'Step 1/11 : FROM ruby' }

      before do
        allow(job).to receive(:batch).and_return(batch)
        allow(batch).to receive(:jobs).and_yield
        allow_any_instance_of(Docker::BuildImage).to receive(:build).and_yield(first_log)
          .and_yield('Step 2/11 : RUN test')
          .and_yield('this lands in test 0')
          .and_yield('Step 3/11 : RUN test')
          .and_yield('Step 4/11 : RUN test')
          .and_yield('Step 5/11 : RUN test')
          .and_yield('this lands in test 4')
          .and_yield('Step 6/11 : RUN test')
          .and_yield('Step 7/11 : RUN test')
          .and_yield('Step 8/11 : RUN test')
          .and_yield('Step 9/11 : RUN test')
          .and_yield('Step 10/11 : RUN test')
          .and_yield('Step 11/11 : RUN test')
        allow_any_instance_of(Docker::BuildImage).to receive(:image).and_return(image)
      end

      it 'adds to batch AfterBuildImage' do
        subject
        expect(Runner::AfterBuildImageJob).to have_enqueued_sidekiq_job(build.id, build_image.id)
      end

      it 'publishes build output' do
        expect { subject }.to broadcast(:build_step_output, image_step, first_log)
      end

      it 'publishes build start' do
        expect { subject }.to broadcast(:build_step_started, image_step)
      end

      it 'publishes build done' do
        expect { subject }.to broadcast(:build_step_done, image_step)
      end

      describe '#seek_step' do
        with_events
        before { subject }

        it { expect(build.reload).to be_running }
        it { expect(build.steps.done.count).to eq(10) }
        it { expect(build.steps.for_images.first.output).to eq(['Step 1/11 : FROM ruby', 'Step 2/11 : RUN test', 'this lands in test 0']) }
        it { expect(build.steps.for_images[3].output).to eq(['Step 5/11 : RUN test', 'this lands in test 4']) }
      end

      describe '#update logs' do
        with_events
        before { subject }
        it { expect(build.steps.done.count).to eq(10) }
      end
    end

    context 'failure' do
      with_events
      before do
        allow_any_instance_of(Docker::BuildImage).to receive(:build).and_raise(Docker::Error::UnexpectedResponseError.new('boom'))
      end

      before do
        expect { subject }.to raise_error(/boom/i)
        build.reload
      end

      it { expect(build.steps.done.count).to eq(0) }
      it { expect(build.steps.failed.count).to eq(1) }
    end
  end
end
