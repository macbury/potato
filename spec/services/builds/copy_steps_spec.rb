# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Builds::CopySteps do
  let(:build) { create(:build, :with_project) }
  subject { described_class.new(build).call }

  describe '#call' do
    before { subject }

    it { expect(build.steps).not_to be_empty }
    it { expect(build.steps.normal.count).to eq(2) }
    it { expect(build.steps.after_build.count).to eq(3) }
    it { expect(build.steps.map(&:owner_type)).to eq(["Image", "Image", "Image", "Image", "Pipeline"]) }

    it 'inserts git clone' do
      expect(build.steps.for_images.after_build.first.command).to match(/git clone/)
    end
  end
end
