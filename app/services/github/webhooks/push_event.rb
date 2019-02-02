module Github
  module Webhooks
    class PushEvent < BaseService
      step :parse_ref
      step :create_build

      private

      def parse_ref(sha:, ref:, project:)
        Success(
          branch: ref.split('/')[-1],
          project: project,
          sha: sha
        )
      end

      def create_build(sha:, project:, branch:)
        build = Builds::Create.new(sha: sha, project: project, branch: branch).call
        if build.persisted?
          Success(build)
        else
          Failure(build.errors)
        end
      end
    end
  end
end
