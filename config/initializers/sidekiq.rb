require 'sidekiq/throttled'
require_relative '../../lib/sidekiq/middlewares/cancellable'

REDIS_URL = ENV.fetch('REDIS_URL')
Sidekiq.default_worker_options = { backtrace: true, retry: 25, dead: false }

Sidekiq.configure_server do |config|
  job_count = ENV.fetch('SIDEKIQ_CONCURRENCY', 50).to_i
  config.options[:concurrency] = job_count
  config.redis = ConnectionPool.new(size: job_count + 5, timeout: 5) do 
    Redis.new(url: REDIS_URL)
  end

  config.server_middleware do |chain|
    chain.add Sidekiq::Middlewares::Cancellable
  end

  config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
  config['pool'] = job_count + 1
  
  ActiveRecord::Base.establish_connection(config)

  schedule_file = Rails.root.join('config/schedule.yml')
  Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file.to_s)) if schedule_file.exist?
end

Sidekiq.configure_client do |config|
  config.redis = { url: REDIS_URL }
end

Sidekiq::Throttled.setup!
