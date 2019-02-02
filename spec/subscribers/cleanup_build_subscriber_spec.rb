# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CleanupBuildSubscriber do
  subject { described_class.new }
  let(:project_build) { create(:build, :with_project) }

  describe '#build_done' do
    it 'cleanups directory' do
      FileUtils.mkdir_p(project_build.temp_path)
      expect(project_build.temp_path).to be_exist
      subject.build_done(project_build)
      expect(project_build.temp_path).not_to be_exist

      build_image = project_build.images.first
      expect(Runner::CleanupImageJob).to have_enqueued_sidekiq_job(project_build.id, build_image.id)
    end
  end

  describe '#build_failed' do
    it 'cleanups directory' do
      FileUtils.mkdir_p(project_build.temp_path)
      expect(project_build.temp_path).to be_exist
      subject.build_done(project_build)
      expect(project_build.temp_path).not_to be_exist

      build_image = project_build.images.first
      expect(Runner::CleanupImageJob).to have_enqueued_sidekiq_job(project_build.id, build_image.id)
    end
  end
end
