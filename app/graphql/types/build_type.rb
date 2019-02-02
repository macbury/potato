module Types
  class BuildType < GraphQL::Schema::Object
    field :project, ProjectType, null: false

    field :id, Integer, null: false
    field :number, Integer, null: false
    field :status, String, null: false

    field :sha, String, null: false
    field :branch, String, null: false
    field :author, AuthorType, null: false
    field :message, String, null: false

    field :output, [String], null: false
    field :steps, [StepType], null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :started_at, GraphQL::Types::ISO8601DateTime, null: true
    field :finished_at, GraphQL::Types::ISO8601DateTime, null: true
    field :duration, Integer, null: false

    def author
      object.user || { name: object.author_name, email: object.author_github_id }
    end

    def output
      object.steps.flat_map(&:output)
    end
  end
end
