module Inputs
  class ImageAttributes < GraphQL::Schema::InputObject
    argument :id, Integer, required: true
    argument :build_script, String, required: true
    argument :setup_script, String, required: true
    argument :name, String, required: true
    argument :caches, [String], required: true
  end
end
