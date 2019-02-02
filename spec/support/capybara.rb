require 'capybara/rails'
require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(no-sandbox disable-popup-blocking disable-gpu window-size=1280,1024) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu no-sandbox disable-popup-blocking disable-gpu window-size=1280,1024) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.default_driver = Capybara.javascript_driver = :chrome
Capybara.default_max_wait_time = 10
Capybara.threadsafe = true

RSpec.configure do |config|
  config.after type: :feature do
    Capybara.reset_sessions!
  end
end
