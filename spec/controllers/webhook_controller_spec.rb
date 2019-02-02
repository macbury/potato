require 'rails_helper'

RSpec.describe WebhookController, type: :controller do
  describe '#github' do
    let(:web_hook) { create(:web_hook) }
    let(:project) { web_hook.project }
    let(:signature_valid) { true }
    before { allow_any_instance_of(WebHook).to receive(:valid_sig?).and_return(signature_valid) }
    

    context 'push event' do
      let(:ref) { 'refs/heads/master' }
      let(:head_commit) { { id: 'abc-sha' } }

      it 'creates new build' do
        request.headers['HTTP_X_GITHUB_EVENT'] = 'push'
        service = double('Github::Webhooks::PushEvent')
        expect(service).to receive(:call).with(project: project, ref: ref, sha: head_commit[:id])
        expect(Github::Webhooks::PushEvent).to receive(:new).and_return(service)

        post :github, params: { 
          id: web_hook.id, ref: ref, head_commit: head_commit 
        }
        
        expect(response).to be_successful
      end
    end

    context 'unsupported event' do
      it 'don`t do anything' do
        post :github, params: { id: web_hook.id }
        expect(response).to be_successful
      end
    end

    context 'not existing' do
      it 'show 404 error' do
        expect { post :github, params: { id: 111 } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context 'wrong signature' do
      let(:signature_valid) { false }
      it 'show 403 error' do
        post :github, params: { id: web_hook.id }
        expect(response.status).to eq(403)
      end
    end
  end
end
