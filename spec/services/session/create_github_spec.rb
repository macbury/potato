# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session::CreateGithub do
  describe '#call' do
    let(:omniauth) do
      {
        "uid" => 1234567890,
        "info" => {
          "email" => 'macbury@test.local',
          "nickname" => 'macbury',
          "image" => 'https://avatars0.githubusercontent.com/u/110908?v=4'
        },
        "credentials" => {
          "token" => "abcde"
        }
      }
    end

    before do
      stub_request(:get, 'https://avatars0.githubusercontent.com/u/110908?v=4').to_return(
        status: 200,
        body: File.open(Rails.root.join('spec/fixtures/avatars/example.jpg')),
        headers: {}
      )
    end

    let(:params) { {} }

    subject { described_class.new.call(omniauth: omniauth, params: params) }
    let(:user) { subject.success }

    it { is_expected.to be_success }
    it { expect { subject }.to change(User, :count).by(1) }

    context 'first boot' do
      let(:params) { { 'first_setup' => true } }

      context 'without super admin' do
        it { is_expected.to be_success }
        it { expect { subject }.to change(User, :count).by(1) }
        it { expect(user).not_to be_access_locked }
        it { expect(user).to be_superadmin }
      end

      context 'with super admin' do
        before { create(:user, role: :superadmin) }

        it { is_expected.to be_failure }
        it { expect { subject }.to change(User, :count).by(1) }
        it { expect(subject.failure).to eq('Setup already completed') }
      end
    end

    describe 'valid user' do
      it { expect(user.email).to eq('macbury@test.local') }
      it { expect(user.token).to eq('abcde') }
      it { expect(user.name).to eq('macbury') }
      it { expect(user.avatar).to be_attached }
      it { expect(user.github_id).to eq(1234567890) }
      it { expect(user).to be_access_locked }
      it { expect(user).to be_developer }
    end
  end
end
