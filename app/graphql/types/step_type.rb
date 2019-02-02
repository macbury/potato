module Types
  class StepType < GraphQL::Schema::Object
    field :id, Integer, null: false
    field :status, String, null: false
    field :command, String, null: false
    field :output, [String], null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :owner, OwnerType, null: false
    field :group, String, null: false

    def group
      object.owner.cache_key
    end
  end
end
