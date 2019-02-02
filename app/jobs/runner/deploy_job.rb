# frozen_string_literal: true

module Runner
  class DeployJob < StepsJob
    attr_reader :build, :deploy

    sidekiq_options queue: :deploy
    sidekiq_throttle concurrency: { limit: 1, key_suffix: ->(build_id, _image_id) { build_id } }

    def perform(build_id, deploy_ids)
      @build = Build.find(build_id)
      @deploy = Deploy.find(deploy_ids.shift)
      
      run

      batch { DeployJob.perform_async(build_id, deploy_ids) }
    end

    private

    def steps
      @steps ||= build.steps.for_owner(deploy).order(:id).to_a
    end

    def image_name
      "#{pipeline.image.docker_name}:#{build.id}"
    end
  end
end
