# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateProject do
  describe '#call' do
    before do
      create(:user, :as_superadmin)
      expect(Github::Client).to receive(:provide).and_return(client)
    end

    let(:client) { double('Github::Client', repository: double('repository', ssh_url: 'git@test.local:yolo/potato.git')) }
    let(:name) { 'the new project' }
    let(:repository_id) { 666 }

    subject { described_class.new(repository_id: repository_id, name: name).call }
    let(:project) { subject.success }

    it { is_expected.to be_success }

    it { expect { subject }.to change(Project, :count).by(1) }
    it { expect { subject }.to change(Image, :count).by(1) }
    it { expect { subject }.to change(Pipeline, :count).by(1) }
    it { expect { subject }.to change(Step, :count).by(0) }

    it { expect(project.ssh_keys).not_to be_empty }
    it { expect(project.git).to eq('git@test.local:yolo/potato.git') }
  end
end
