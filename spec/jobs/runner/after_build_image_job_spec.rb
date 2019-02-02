# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runner::AfterBuildImageJob do
  it { is_expected.to be_processed_in :builds }
  it { is_expected.to be_retryable 0 }
  it { is_expected.to save_backtrace }

  describe '#perform' do
    let(:build) { create(:build, :with_project, :is_running, steps: 2) }
    let(:build_image) { build.project.images.first }

    let(:job) { described_class.new }
    let(:runner) { double('Docker::ContainerRunner', commit: nil) }
    subject { job.perform(build.id, build_image.id) }

    before do
      allow(Docker::ContainerRunner).to receive(:new).with(build_image.docker_name, logger: kind_of(Logger)).and_return(runner)
      allow(runner).to receive(:boot).and_yield
      allow(runner).to receive(:exec).exactly(4).times.and_yield('random output').and_return(true)
    end

    it 'run only after_build steps' do
      steps = build.steps.for_owner(build_image).after_build.to_a
      expect(steps.size).to eq(4)

      expect { subject }.to broadcast(:build_step_started, steps[0])
                            .and(broadcast(:build_step_started, steps[1]))
    end

    it 'commits and saves image' do
      expect(runner).to receive(:commit).with("#{build_image.docker_name}:#{build.id}")
      subject
    end

    describe 'directory caching' do
      let(:cache) { double('Docker::Cache') }
      before do
        build_image.update_attributes(caches: ['node_modules/'])
        allow(runner).to receive(:cache).and_return(cache)
        allow(runner).to receive(:fetch_file).with(
          "/tmp/potato_cache_#{build_image.id}.tgz",
          Rails.root.join("tmp/cache/images/#{build_image.id}.tgz"),
        )
        allow(runner).to receive(:exec).and_return(true)
        allow(runner).to receive(:put_file).with(
          Rails.root.join("tmp/cache/images/#{build_image.id}.tgz"),
          "/tmp/potato_cache_#{build_image.id}.tgz"
        )

        allow(cache).to receive(:with).with(runner).and_yield
      end

      it 'store and restore cache' do
        subject
      end
    end
  end
end
