module Types
  class ProjectType < GraphQL::Schema::Object
    field :name, String, null: false
    field :git, String, null: false
    field :id, Integer, null: false

    field :builds, resolver: Resolvers::Builds

    field :images, [ImageType], null: false
    field :pipelines, [PipelineType], null: false
  end
end
