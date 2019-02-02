module Types
  class MutationType < GraphQL::Schema::Object
    field :create_project, mutation: Mutations::CreateProject
    field :create_build, mutation: Mutations::CreateBuild
    field :update_image, mutation: Mutations::UpdateImage
  end
end
