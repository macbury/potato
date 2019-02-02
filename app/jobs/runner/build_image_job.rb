# frozen_string_literal: true

module Runner
  class BuildImageJob < ApplicationJob
    STEP_REGEXP = /Step (\d+)\/(\d+) : .+/i.freeze
    START_FROM_STEP = 2

    attr_reader :build, :image, :current_step

    sidekiq_options queue: :builds
    sidekiq_throttle concurrency: { limit: 1, key_suffix: ->(_build_id, image_id) { image_id } }

    def perform(build_id, image_id)
      @build = Build.find(build_id)
      @image = Image.find(image_id)
      @current_step = steps.first

      reset_steps
      build_image
      batch.jobs { AfterBuildImageJob.perform_async(build.id, image.id) }
    rescue Sidekiq::CancelWorker => e
      broadcast(:build_step_cancelled, current_step) if current_step
      raise e
    rescue Docker::Error::UnexpectedResponseError, Sidekiq::CancelWorker, Docker::Error::TimeoutError => e
      broadcast(:build_step_failed, current_step)
      raise e
    end

    private

    def reset_steps
      ActiveRecord::Base.transaction do
        steps.each do |step|
          step.update_attributes(status: :pending, output: [])
        end
      end
    end

    def build_image
      broadcast(:build_step_started, current_step) if current_step

      builder.build do |output|
        seek_step(output)
        broadcast(:build_step_output, current_step, output) if current_step
      end

      broadcast(:build_step_done, current_step) if current_step
    end

    def seek_step(output)
      matched_step = output.match(STEP_REGEXP)
      return unless matched_step

      step_index = matched_step[1].to_i
      return unless step_index >= START_FROM_STEP

      next_step = steps[step_index - START_FROM_STEP] || steps.last

      if current_step != next_step
        broadcast(:build_step_done, current_step)
        broadcast(:build_step_started, next_step)
        @current_step = next_step
      end
    end

    def steps
      @steps ||= build.steps.for_owner(image).normal.order(:id)
    end

    def builder
      @builder ||= Docker::BuildImage.new(image.docker_name, image.to_dockerfile)
    end
  end
end
