module Types
  class ImageType < GraphQL::Schema::Object
    field :id, Integer, null: false
    field :base, String, null: false
    field :name, String, null: false
    field :build_script, String, null: false
    field :setup_script, String, null: false
    field :caches, [String], null: false
    field :project, ProjectType, null: false
  end
end
