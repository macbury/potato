module Enums
  class Order < GraphQL::Schema::Enum
    value 'Newest', value: :desc
    value 'Oldest', value: :asc
  end
end
