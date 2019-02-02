module Resolvers
  class Build < GraphQL::Schema::Resolver
    type Types::BuildType, null: true

    argument :id, Integer, required: true, description: 'Build id to find'

    def resolve(id:)
      ::Build.where(id: id).first
    end
  end
end
