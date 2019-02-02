class Types::SubscriptionType < GraphQL::Schema::Object
  field :step, resolver: Resolvers::Step
  field :build, resolver: Resolvers::AnyBuild

  field :step_output, Types::StepOutputType, null: true do
    argument :id, Integer, required: true
  end

  def step_output(id:)
    
  end
end
