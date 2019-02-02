module Resolvers
  class Projects < GraphQL::Schema::Resolver
    type Types::ProjectType.connection_type, null: false

    def resolve
      ::Project.order(:id)
    end
  end
end
