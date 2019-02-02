require 'rails_helper'

RSpec.describe WebHook, type: :model do
  it { is_expected.to belong_to(:project) }

  describe '#create' do
    subject { create(:web_hook) }

    it { expect(subject.secret).not_to be_nil }

    it 'broadcast web_hook_created event' do
      expect { subject }.to broadcast(:web_hook_created, kind_of(WebHook))
    end
  end

  describe '#valid_sig?' do
    let(:web_hook) { create(:web_hook).tap { |wh| wh.update_attributes(secret: 'yolo') } }
    let(:body) { double('Body', rewind: true, read: '{ "json": true }') }
    let(:request) { double('Request', body: body) }

    subject { web_hook.valid_sig?(request, signature) }

    context 'valid signature' do
      let(:signature) { 'sha1=ef1cef166f7e753ff120729d26edd7ae8b81f051' }
      it { is_expected.to be(true) }
    end

    context 'invalid signature' do
      let(:signature) { 'sha1=ssss' }
      it { is_expected.to be(false) }
    end
  end
end
