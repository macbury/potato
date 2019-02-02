# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebHooksSubscriber do
  subject { described_class.new }

  describe '#web_hook_created', setup_complete: true do
    let(:web_hook) { create(:web_hook) }
    let(:client) { double('OctokitClient', create_hook: true) }
    before { allow(Github::Client).to receive(:provide).and_return(client) }

    it 'creates new webhook using Github api' do
      subject.web_hook_created(web_hook)
    end
  end
end