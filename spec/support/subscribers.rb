# frozen_string_literal: true

require 'wisper/rspec/matchers'

module SubscribersSupport
  def with_events
    before do 
      allow(Github::Client).to receive(:add_deploy_key)
      Subscribers.subscribe_all
    end

    after do
      Wisper.clear
    end
  end
end

RSpec.configure do |config|
  config.include(Wisper::RSpec::BroadcastMatcher)
  config.extend(SubscribersSupport)
end

class DummyPublisher
  include Wisper::Publisher

  def self.method_missing(name, *args)
    new.broadcast(name, *args)
  end

  def broadcast(*args)
    super(*args)
  end
end
