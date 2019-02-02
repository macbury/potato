require 'rspec/retry'

RSpec.configure do |config|
  config.verbose_retry = true
  config.default_retry_count = 2
  config.exceptions_to_retry = [Net::ReadTimeout]
end
