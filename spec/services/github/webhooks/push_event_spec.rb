require 'rails_helper'

RSpec.describe Github::Webhooks::PushEvent do
  describe '#call' do
    let(:project) { build.project }
    let!(:build) { create(:build, :with_project) }
    subject { described_class.new.call(project: project, ref: ref_param, sha: sha) }

    let(:ref_param) { 'refs/heads/apiExplorer' }
    let(:sha) { 'token-sha' }

    before do
      allow(Builds::Create).to receive(:new).with(project: project, branch: 'apiExplorer', sha: 'token-sha').and_return(double(call: build))
    end

    it { is_expected.to be_success }
    it { expect(subject.success).to eq(build) }
  end
end
