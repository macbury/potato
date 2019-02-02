module Types
  class QueryType < GraphQL::Schema::Object
    field :repositories, resolver: Resolvers::Repositories, null: true, description: 'List all github repositories assigned to superadmin'

    field :projects, resolver: Resolvers::Projects, null: true, description: 'List all projects'
    field :project, resolver: Resolvers::Project, null: true, description: 'Fetch one project'

    field :builds, resolver: Resolvers::Builds, null: true, description: 'List all builds in system'
    field :build, resolver: Resolvers::FindBuild, null: true, description: 'Find one build'

    field :me, resolver: Resolvers::CurrentUser, null: true, description: 'Show information about current user'
  end
end
