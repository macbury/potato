require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe '#associations' do
    it { is_expected.to have_many(:builds) }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_presence_of(:github_id) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#create' do
    it { is_expected.to be_access_locked }
    it { is_expected.to be_developer }
  end
end
