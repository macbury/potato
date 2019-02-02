# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildsStepsSubscriber do
  subject { described_class.new }
  let(:project_build) { create(:build, :with_project, :is_running) }
  let(:image_step) { project_build.steps.for_images.first }

  describe '#build_started' do
    before { subject.build_step_started(image_step) }
    it 'changes pending to running' do
      expect(project_build).to be_running
    end
  end
end
