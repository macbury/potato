# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SshKey, type: :model do
  it { is_expected.to belong_to(:project) }

  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:project_id) }

  describe '#new' do
    subject { create(:ssh_key) }
    it 'broadcast created event' do
      expect { subject }.to broadcast(:ssh_key_created, kind_of(SshKey))
    end

    it { is_expected.to be_clone }
  end

  describe '#generate_ssh' do
    subject { create(:ssh_key) }

    it 'public key not empty' do 
      expect(subject.public_key).not_to be_empty
    end

    it 'private key not empty' do
      expect(subject.private_key).not_to be_empty
    end

    it 'fingerprint key not empty' do 
      expect(subject.fingerprint).not_to be_empty
    end
  end
end
