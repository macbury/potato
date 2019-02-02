# frozen_string_literal: true

module Runner
  class AfterBuildImageJob < StepsJob
    attr_reader :build, :image

    sidekiq_options queue: :builds
    sidekiq_throttle concurrency: { limit: 1, key_suffix: ->(_build_id, image_id) { image_id } }

    def perform(build_id, image_id)
      @build = Build.find(build_id)
      @image = Image.find(image_id)

      run do
        run_git_clone

        cache.with(runner) { exec_all_steps }

        runner.commit("#{image.docker_name}:#{build.id}")
      end
    end

    private

    def run_git_clone
      next_step
      exec_step
    end

    def cache
      @cache ||= Docker::Cache.new(image)
    end

    def steps
      @steps ||= build.steps.for_owner(image).after_build.order(:id).to_a
    end

    def image_name
      image.docker_name
    end
  end
end
