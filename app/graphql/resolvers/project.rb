module Resolvers
  class Project < GraphQL::Schema::Resolver
    type Types::ProjectType, null: true

    argument :id, Integer, required: true, description: 'Project id to find'

    def resolve(id:)
      ::Project.where(id: id).first
    end
  end
end
