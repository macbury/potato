# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '>= 4.0.x'

gem 'dotenv-rails'
gem 'redis', '~> 4.0'
gem 'sidekiq'
gem 'sidekiq-batch', '~> 0.1.5'
gem 'sidekiq-cron'
gem 'sidekiq-throttled'
gem 'octokit'
gem 'docker-api', '~> 1.34', '>= 1.34.2'

gem 'attr_encrypted'
gem 'pry'
gem 'rails-pry'
gem 'tty-command'
gem 'wisper'
gem 'sshkey'

gem 'bootsnap', '>= 1.1.0', require: false

gem 'devise'
gem 'omniauth'
gem 'omniauth-github'

gem 'haml-rails'

gem 'dry-transaction'
gem 'mini_magick'
gem 'graphql'
gem 'gravatar'
gem 'i18n-js'
gem 'rack-cors', require: 'rack/cors'

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'rspec-retry'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller'
end

group :test do
  gem 'database_cleaner', '~> 1.7'
  gem 'factory_bot', '~> 4.10'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fakeredis', require: false
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers', require: 'shoulda/matchers'
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
  gem 'wisper-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
