# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Docker::BuildImage do
  subject { described_class.new(random_name, dockerfile) }

  let(:dockerfile) { double('Dockerfile', to_s: 'invalid') }
  let(:random_name) { 'test' }
  let(:image) { double('Docker::Image', id: 'yolo') }

  context 'success' do
    let(:log) { '{ "stream": "One step to go" }' }

    it 'creates temp dir' do
      expect(subject.temp_dir).to be_exist
    end

    it 'builds stuff using docker api' do
      expect(Docker::Image).to receive(:build_from_dir).and_yield(log).and_return(image)
      expect(image).to receive(:tag).with(repo: random_name)

      expect { |b| subject.build(&b) }.to yield_with_args("One step to go")
      expect(subject.image.id).to eq('yolo')
    end
  end
end
