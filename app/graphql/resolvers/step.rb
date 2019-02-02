module Resolvers
  class Step < GraphQL::Schema::Resolver
    type Types::StepType, null: true

    argument :id, Integer, required: true, description: 'Step id to find'

    def resolve(id:)
      ::Step.where(id: id).first
    end
  end
end
