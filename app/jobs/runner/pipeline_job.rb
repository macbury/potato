# frozen_string_literal: true

module Runner
  class PipelineJob < StepsJob
    attr_reader :build, :pipeline

    sidekiq_options queue: :pipeline
    sidekiq_throttle concurrency: { limit: ENV.fetch('MAX_BUILDS') }

    def perform(build_id, pipeline_id)
      @build = Build.find(build_id)
      @pipeline = Pipeline.find(pipeline_id)

      run do
        exec_all_steps
      end
    end

    private

    def steps
      @steps ||= build.steps.for_owner(pipeline).order(:id).to_a
    end

    def image_name
      "#{pipeline.image.docker_name}:#{build.id}"
    end
  end
end
