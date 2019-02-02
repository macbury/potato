# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image, type: :model do
  it { is_expected.to belong_to(:project) }
  it { is_expected.to have_many(:steps) }

  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:project_id) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:base) }

  describe '#new' do
    subject { Image.new }

    it { expect(subject.base).to eq('potato-base:latest') }
  end

  describe '#docker_name' do
    subject { create(:image, :with_project) }

    it { expect(subject.docker_name).not_to be_empty }
  end

  describe '#to_dockerfile' do
    subject { create(:image, :with_project, :with_steps, steps: 2) }

    it {
      expect(subject.to_dockerfile.to_s).to eq("FROM ruby:latest\nRUN normal command: 0\nRUN normal command: 1")
    }
  end
end
