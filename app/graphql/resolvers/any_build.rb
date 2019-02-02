module Resolvers
  class AnyBuild < GraphQL::Schema::Resolver
    type Types::BuildType, null: true

    argument :id, Integer, required: false, description: 'Build id to find'

    def resolve(id: nil)
      ::Build.where(id: id).first
    end
  end
end
