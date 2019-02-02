# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Step, type: :model do
  it { is_expected.to belong_to(:owner) }
  it { is_expected.to belong_to(:build) }
  it { is_expected.to validate_presence_of(:command) }

  it 'kind is pending' do
    expect(described_class.new).to be_pending
  end

  it 'trigger is normal' do
    expect(described_class.new).to be_normal
  end
end
