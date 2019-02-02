module Types
  class CurrentUserType < GraphQL::Schema::Object
    field :id, Integer, null: false
    field :email, String, null: false
    field :name, String, null: false
    field :avatar_url, String, null: false

    def avatar_url
      object.avatar.attached? ? Rails.application.routes.url_helpers.url_for(object.avatar) : Gravatar.new(object.email).url
    end
  end
end
