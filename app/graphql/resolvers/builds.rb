module Resolvers
  class Builds < GraphQL::Schema::Resolver
    type Types::BuildType.connection_type, null: false

    argument :order, Enums::Order, required: false, default_value: :asc

    def resolve(order: :asc)
      query = ::Build.order(order == :asc ? 'created_at ASC' : 'created_at DESC')
      query = query.where(project_id: object.id) if object
      query
    end
  end
end
