# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Docker::ContainerRunner do
  subject { described_class.new('test-image') }
  describe '#boot' do
    let(:container) { double('Docker::Container', start: true, kill: true, delete: true, exec: ['', '', 0], store_file: true) }

    it 'creates container' do
      expect(Docker::Container).to receive(:create).with(
        'Image' => 'test-image',
        'Tty' => true,
        'OpenStdin' => true,
        'StdinOnce' => false,
        'Privileged' => true,
        'Env' => ['A=B']
      ).and_return(container)
      subject.boot(env: { A: 'B' }, keys: { key: 'value' })
    end

    it 'pushes ssh keys' do
      expect(subject).to receive(:container).and_return(container).at_least(:once)
      expect(container).to receive(:store_file).with('/root/.ssh/key_example', 'value')
      expect(subject).to receive(:exec).with('ssh-agent -a ${SSH_AUTH_SOCK}', tty: false).and_return(true)
      expect(subject).to receive(:exec).with('chmod 0600 /root/.ssh/key_example')
      expect(subject).to receive(:exec).with('ssh-add /root/.ssh/key_example')
      subject.boot(keys: { example: 'value' })
    end

    it 'cleanup container' do
      expect(subject).to receive(:container).and_return(container).at_least(:once)
      expect(container).to receive(:start)
      expect(container).to receive(:kill)
      expect(container).to receive(:delete)
      subject.boot(keys: { example: 'value' })
    end
  end

  describe '#exec' do
    let(:container) { double('Docker::Container', start: true, kill: true, delete: true) }
    before do
      allow(subject).to receive(:container).and_return(container)
      allow(container).to receive(:exec).with(['/bin/bash', '-l', '-c', 'ls'], tty: true).and_yield(stderr || stdout, output_type).and_return([stdout, stderr, code])
    end

    context 'command was success' do
      let(:stderr) { nil }
      let(:stdout) { "/home\n/root" }
      let(:output_type) { 'stdout' }
      let(:code) { 0 }

      it 'yields logs' do
        expect { |b| subject.exec('ls', &b) }.to yield_with_args(stdout)
      end

      it { expect(subject.exec('ls')).to be_truthy }
    end

    context 'command exploded' do
      let(:stderr) { 'command ls not found' }
      let(:stdout) { nil }
      let(:output_type) { 'stderr' }
      let(:code) { 127 }

      it 'yields logs' do
        expect { |b| subject.exec('ls', &b) }.to yield_with_args('command ls not found')
      end

      it { expect(subject.exec('ls')).to be_falsy }
    end
  end
end
