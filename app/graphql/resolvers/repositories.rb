module Resolvers
  class Repositories < GraphQL::Schema::Resolver
    type [Types::RepositoryType], null: false

    def resolve
      Github::FetchRepositories.call.success
    end
  end
end
