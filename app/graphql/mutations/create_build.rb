module Mutations
  class CreateBuild < GraphQL::Schema::Mutation
    null false

    argument :project_id, Integer, required: true
    argument :branch, String, required: false
    argument :sha, String, required: false

    field :build, Types::BuildType, null: true
    field :errors, [String], null: false

    def resolve(project_id:, branch: nil, sha: nil)
      project = Project.where(id: project_id).first
      build = Builds::Create.new(
        project: project, 
        branch: branch, 
        sha: sha
      ).call

      if build.persisted?
        return {
          build: build,
          errors: []
        }
      else
        return {
          errors: build.errors.full_messages
        }
      end
    end
  end
end
