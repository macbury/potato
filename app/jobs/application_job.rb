# frozen_string_literal: true

class ApplicationJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  include Wisper::Publisher

  sidekiq_options retry: 0, backtrace: true
end
