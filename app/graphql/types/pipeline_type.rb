module Types
  class PipelineType < GraphQL::Schema::Object
    field :id, Integer, null: false
    field :name, String, null: false
    field :script, String, null: false
    field :group, String, null: false
  end
end
