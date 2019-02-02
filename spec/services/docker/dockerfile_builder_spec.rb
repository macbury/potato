# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Docker::DockerfileBuilder do
  subject { Docker::DockerfileBuilder.new('ruby:latest') }

  before do
    subject.run('apt-get update')
    subject.run('apt-get install htop -y')
  end

  it 'generates content' do
    expect(subject.to_s).to eq([
      'FROM ruby:latest',
      'RUN apt-get update',
      'RUN apt-get install htop -y'
    ].join("\n"))
  end
end
