# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runner::PipelineJob do
  it { is_expected.to be_processed_in :pipeline }
  it { is_expected.to be_retryable 0 }
  it { is_expected.to save_backtrace }

  describe '#perform' do
    let!(:build) { create(:build, :with_project, :is_running, steps: 5) }
    let(:pipeline) { build.pipelines.first }
    let(:steps) { build.steps.for_owner(pipeline).to_a }

    let(:runner) { double('Docker::ContainerRunner') }
    let(:image_name) { "#{pipeline.image.docker_name}:#{build.id}" }
    before { allow(Docker::ContainerRunner).to receive(:new).with(image_name, logger: kind_of(Logger)).and_return(runner) }

    subject { described_class.new.perform(build.id, pipeline.id) }

    it 'sends all project keys to runner' do
      expect(runner).to receive(:boot).with(keys: {
        'pipeline' => kind_of(String)
      })
      subject
    end

    context 'run all commands with success' do
      let(:stdout) { 'step command output' }
      before do
        allow(runner).to receive(:boot).and_yield
        allow(runner).to receive(:exec).exactly(6).times.and_yield(stdout).and_return(true)
      end

      it 'broadcasts build step started' do
        expect { subject }.to broadcast(:build_step_started, steps[0])
                              .and(broadcast(:build_step_started, steps[1]))
                              .and(broadcast(:build_step_started, steps[2]))
                              .and(broadcast(:build_step_started, steps[3]))
                              .and(broadcast(:build_step_started, steps[4]))
      end

      it 'broadcasts build step output' do
        expect { subject }.to broadcast(:build_step_output, steps[0], stdout)
                              .and(broadcast(:build_step_output, steps[1], stdout))
                              .and(broadcast(:build_step_output, steps[2], stdout))
                              .and(broadcast(:build_step_output, steps[3], stdout))
                              .and(broadcast(:build_step_output, steps[4], stdout))
      end

      it 'broadcasts build step done' do
        expect { subject }.to broadcast(:build_step_done, steps[0])
                              .and(broadcast(:build_step_done, steps[1]))
                              .and(broadcast(:build_step_done, steps[2]))
                              .and(broadcast(:build_step_done, steps[3]))
                              .and(broadcast(:build_step_done, steps[4]))
      end

      describe 'marks all steps as done' do
        with_events

        before { subject }

        it do
          expect(build.steps.for_owner(pipeline).done.count).to eq(5)
        end
      end
    end

    context 'one commands fails' do
      let(:stderr) { 'command failed...' }

      before do
        allow(runner).to receive(:boot).and_yield
        allow(runner).to receive(:exec).once.and_yield(stderr).and_return(false)
      end

      it 'broadcasts build step started only for first step' do
        expect { subject }.to broadcast(:build_step_started, steps[0])
      end

      it 'dont broadcasts build step started for second step' do
        expect { subject }.not_to broadcast(:build_step_started, steps[1])
      end

      it 'broadcasts build step output' do
        expect { subject }.to broadcast(:build_step_output, steps[0], stderr)
      end

      it 'broadcasts build step failed' do
        expect { subject }.to broadcast(:build_step_failed, steps[0])
      end

      describe 'mark first step as failed' do
        with_events

        it do
          subject
          expect(build.steps.for_owner(pipeline).failed.count).to eq(1)
          expect(build.steps.for_owner(pipeline).pending.count).to eq(4)
        end
      end
    end
  end
end
