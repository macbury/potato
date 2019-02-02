module Types
  class AuthorType < GraphQL::Schema::Object
    field :id, Integer, null: false
    field :name, String, null: false
    field :avatar_url, String, null: false

    def avatar_url
      if object.kind_of?(User)
        Rails.application.routes.url_helpers.url_for(object.avatar)
      else
        Gravatar.new(object[:email]).url
      end
    end
  end
end
