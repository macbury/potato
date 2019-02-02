# frozen_string_literal: true

module Runner
  class StepsJob < ApplicationJob
    attr_reader :current_step
    private

    def reset_steps
      ActiveRecord::Base.transaction do
        steps.each do |step|
          step.update_attributes(status: :pending, output: [])
        end
      end
    end

    def image_name
      not_implemented
    end

    def steps
      not_implemented
    end

    def run(&block)
      reset_steps
      runner.boot(keys: keys) do
        block&.call
      end
    rescue Sidekiq::CancelWorker => e
      broadcast(:build_step_cancelled, current_step) if current_step
      raise e
    end

    def exec_all_steps
      while next_step
        break unless exec_step
      end
    end

    def keys
      build.ssh_keys.each_with_object({}) do |key, keys|
        keys[key.name] = key.private_key
      end
    end

    def next_step
      @current_step = steps.shift
    end

    def exec_step
      return unless current_step

      broadcast(:build_step_started, current_step)

      success = runner.exec(current_step.command) do |output|
        broadcast(:build_step_output, current_step, output)
      end

      if success
        broadcast(:build_step_done, current_step)
        return true
      else
        broadcast(:build_step_failed, current_step)
        return false
      end
    end

    def runner
      @runner ||= Docker::ContainerRunner.new(image_name, logger: logger)
    end
  end
end
