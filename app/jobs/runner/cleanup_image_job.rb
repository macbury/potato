# frozen_string_literal: true

module Runner
  class CleanupImageJob < ApplicationJob
    sidekiq_throttle concurrency: { limit: 1, key_suffix: ->(_build_id, image_id) { image_id } }

    def perform(build_id, image_id)
      @build = Build.find(build_id)
      @image = Image.find(image_id)

      return unless Docker::Image.exist?(image_name)

      image = Docker::Image.get(image_name)
      image.delete(force: true)
    end

    private

    def image_name
      "#{@image.docker_name}:#{@build.id}"
    end
  end
end
