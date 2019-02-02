class PotatoSchema < GraphQL::Schema
  use GraphQL::Backtrace
  use GraphQL::Subscriptions::ActionCableSubscriptions

  mutation Types::MutationType
  query Types::QueryType
  subscription Types::SubscriptionType
end
