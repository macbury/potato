# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Build, type: :model do
  subject { create(:build, :with_project) }

  describe '#associations' do
    it { is_expected.to have_many(:steps) }
    it { is_expected.to have_many(:images) }
    it { is_expected.to have_many(:pipelines) }
    it { is_expected.to have_many(:ssh_keys) }

    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user) }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of(:sha) }
    it { is_expected.to validate_presence_of(:branch) }
    it { is_expected.to validate_presence_of(:author_name) }
    it { is_expected.to validate_presence_of(:author_github_id) }
    it { is_expected.to validate_presence_of(:message) }
  end

  it 'after create triggers build_created event' do
    expect { subject }.to broadcast(:build_created, kind_of(Build))
  end

  it 'failed! broadcast event' do
    expect { subject.failed! }.to broadcast(:build_failed, subject)
  end

  it 'done! broadcast event' do
    expect { subject.done! }.to broadcast(:build_done, subject)
  end

  it 'default is pending' do
    expect(described_class.new).to be_pending
  end

  describe '#for_owner' do
    let(:build) { create(:build, :with_project, :is_running, steps: 5) }
    let(:pipeline) { build.pipelines.first }

    subject { build.steps.for_owner(pipeline).order(:id).to_a }

    it { expect(subject.size).to eq(5) }
  end
end
