module Types
  class StepOutputType < GraphQL::Schema::Object
    field :output, [String], null: true
  end
end
