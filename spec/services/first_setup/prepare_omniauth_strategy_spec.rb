# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FirstSetup::PrepareOmniauthStrategy do
  let(:options) { double('options') }
  let(:env) { { 'omniauth.strategy' => double('omniauth.strategy', options: options) } }
  subject { described_class.call(params: params, env: env) }
  let(:params) { {} }

  describe '#call' do
    context 'with first_boot param' do
      let(:params) { { first_setup: true } }

      it 'set omniauth params' do
        expect(options).to receive(:[]=).with('scope', 'user:email,repo,read:org,write:public_key,write:repo_hook')

        is_expected.to be_success
      end
    end

    context 'without first_boot param' do
      it { is_expected.to be_failure }
    end
  end
end
