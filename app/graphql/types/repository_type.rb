module Types
  class RepositoryType < GraphQL::Schema::Object
    field :name, String, null: false
    field :clone_url, String, null: false
    field :id, Integer, null: false
    field :owner, String, null: false
    field :avatar_url, String, null: false

    def owner
      object.dig(:owner, :login)
    end

    def avatar_url
      object.dig(:owner, :avatar_url)
    end

    def clone_url
      object[:ssh_url]
    end
  end
end
