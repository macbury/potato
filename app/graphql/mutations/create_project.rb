module Mutations
  class CreateProject < GraphQL::Schema::Mutation
    null false

    argument :repository_id, Integer, required: true
    argument :name, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: false

    def resolve(repository_id:, name:)
      ::CreateProject.new(repository_id: repository_id, name: name).call do |result|
        result.success do |project|
          return {
            project: project,
            errors: []
          }
        end

        result.failure do |error|
          return {
            errors: [error.to_s]
          }
        end
      end
    end
  end
end
