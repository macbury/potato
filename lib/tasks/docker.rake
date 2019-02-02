# frozen_string_literal: true

namespace :docker do
  desc 'Create base docker image for ci'
  task base: [:environment] do
    Docker::BaseImageBuilder.new.build
  end
end
