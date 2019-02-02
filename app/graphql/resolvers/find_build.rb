module Resolvers
  class FindBuild < GraphQL::Schema::Resolver
    type Types::BuildType, null: true

    argument :id, Integer, required: false

    def resolve(id:)
      ::Build.find_by(id: id)
    end
  end
end
