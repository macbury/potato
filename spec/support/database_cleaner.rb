# frozen_string_literal: true

require 'database_cleaner'

DatabaseCleaner.strategy = :deletion
DatabaseCleaner.clean

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
