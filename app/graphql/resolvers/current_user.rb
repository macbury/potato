module Resolvers
  class CurrentUser < GraphQL::Schema::Resolver
    type Types::CurrentUserType, null: true

    def resolve
      context[:current_user]
    end
  end
end
