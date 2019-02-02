# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FirstSetup::PrepareGithubAccount do
  subject { described_class.call }

  describe '#call' do
    context 'with super admin' do
      before { create(:user, :as_superadmin) }
      it { is_expected.to be_failure }
    end

    context 'without super admin' do
      it { is_expected.to be_success }
      it { expect(subject.success).not_to be_empty }
    end
  end
end