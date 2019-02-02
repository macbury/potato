require_relative './builds_steps_subscriber'
require_relative './builds_subscriber'
require_relative './cleanup_build_subscriber'
require_relative './graphql_subscriber'
require_relative './ssh_keys_subscriber'
require_relative './web_hooks_subscriber'

module Subscribers
  All = [
    BuildsStepsSubscriber,
    BuildsSubscriber,
    CleanupBuildSubscriber,
    WebHooksSubscriber,
    SshKeysSubscriber,
    GraphqlSubscriber
  ]

  def self.subscribe_all
    Rails.logger.debug 'Registering all subscribers.'
    Wisper.clear
    All.each do |subscriber_klass|
      subscriber = subscriber_klass.new
      Wisper.subscribe(subscriber, scope: subscriber.try(:scope))
    end
  end
end
