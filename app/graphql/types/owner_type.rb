module Types
  class OwnerType < GraphQL::Schema::Union
    possible_types Types::PipelineType, Types::ImageType

    def self.resolve_type(object, context)
      if object.is_a?(::Image)
        Types::ImageType
      else
        Types::PipelineType
      end
    end
  end
end
