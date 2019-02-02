# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Builds::Create do
  let(:project) { create(:project, :with_image) }
  let!(:superadmin) { create(:user, :as_superadmin) }

  describe '#call' do
    subject { described_class.new(project: project, branch: branch, sha: sha).call }
    let(:github) { double('Octokit::Client') }
    before { allow(Github::Client).to receive(:provide).and_return(github) }

    context 'passed only branch' do
      let(:branch) { 'dev' }
      let(:sha) { nil }

      before do
        allow(github).to receive(:commits).with(project.repository_id, branch).and_return([
          {
            sha: '1234567890',
            commit: {
              message: 'First commit'
            },
            author: {
              login: 'yolo',
              id: 11111
            }
          }
        ])
      end

      it { is_expected.to be_persisted }
      it { expect(subject.message).to eq('First commit') }
      it { expect(subject.sha).to eq('1234567890') }
      it { expect(subject.author_github_id).to eq('11111') }
      it { expect(subject.author_name).to eq('yolo') }
    end

    context 'passed branch and specified sha of commit' do
      let(:branch) { 'prod' }
      let(:sha) { 'abcsha' }

      before do
        allow(github).to receive(:commits).with(project.repository_id, sha).and_return([
          {
            sha: 'abcsha',
            commit: {
              message: 'First commit'
            },
            author: {
              login: 'yolo',
              id: 1111
            }
          }
        ])
      end

      it { is_expected.to be_persisted }
      it { expect(subject.sha).to eq(sha) }
    end

    context 'author is nil, and we want information from git commit instead' do
      let(:branch) { 'WC-1234_make-this-work' }
      let(:sha) { nil }

      before do
        allow(github).to receive(:commits).with(project.repository_id, branch).and_return([
          {
            sha: 'abcsha',
            commit: {
              message: 'First commit',
              author: {
                name: 'eugeniusz',
                email: 'eugeniusz@email.test'
              }
            }
          }
        ])
      end

      it { is_expected.to be_persisted }
      it { expect(subject.author_github_id).to eq('eugeniusz@email.test') }
      it { expect(subject.author_name).to eq('eugeniusz') }
    end

    context 'invalid sha' do
      let(:branch) { 'yolo' }
      let(:sha) { 'yolo' }

      before do
        allow(github).to receive(:commits).with(project.repository_id, branch).and_raise(Octokit::NotFound.new)
      end

      it { is_expected.not_to be_persisted }
      it { expect(subject.errors.full_messages).to eq(['Could not find branch or commit sha']) }
    end
  end
end
