module Mutations
  class UpdateImage < GraphQL::Schema::Mutation
    null false
    argument :attributes, Inputs::ImageAttributes, required: true

    field :image, Types::ImageType, null: true
    field :errors, [String], null: false

    def resolve(attributes:)
      image = Image.where(id: attributes.id).first
      if image&.update_attributes(attributes.to_h)
        return {
          image: image,
          errors: []
        }
      else
        return {
          image: nil,
          errors: image&.errors&.full_messages || []
        }
      end
    end
  end
end
