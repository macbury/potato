require_relative '../../app/subscribers/subscribers'

Rails.application.config.to_prepare do
  unless Rails.env.test?
    Wisper.clear 
    Subscribers.subscribe_all
  end
end
