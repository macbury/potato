require 'rails_helper'

RSpec.describe Builds::SplitCommands do
  subject { described_class.new.call(script) }

  let(:script) do
    %{
      # We support all major Ruby versions. Please see our documentation for a full list.
      # https://documentation.codeship.com/basic/languages-frameworks/ruby/
      # If `.ruby-version` file is present, RVM will set Ruby to the declared version.
      if [ -f .ruby-version ]; then rvm use $(cat .ruby-version) --install; fi
      # If you are not using a `.ruby-version` in your project,
      # then the desired version of Ruby can be declared in the following manner:
      # rvm use 2.2.3 --install
      bundle install
      # Make sure Ruby on Rails knows we are in the the test environment.
      export RAILS_ENV=test
      export REDIS_VERSION=4.0.2
      curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/redis.sh | bash -s
      cp .env.example .env
      # Prepare the test database
      bundle exec rake db:create
      bundle exec rake db:migrate
    }
  end

  it 'ignores empty lines and comments' do
    is_expected.to eq([
      'if [ -f .ruby-version ]; then rvm use $(cat .ruby-version) --install; fi',
      'bundle install',
      'export RAILS_ENV=test',
      'export REDIS_VERSION=4.0.2',
      'curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/redis.sh | bash -s',
      'cp .env.example .env',
      'bundle exec rake db:create',
      'bundle exec rake db:migrate'
    ])
  end
end