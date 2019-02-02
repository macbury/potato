require 'sidekiq/web'
require 'sidekiq/throttled/web'
require 'sidekiq/cron/web'

Sidekiq::Throttled::Web.enhance_queues_tab!

Rails.application.routes.draw do
  default_url_options host: ENV.fetch('POTATO_HOST'), port: ENV.fetch('POTATO_PORT')

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq/workers'
  end

  match '/api', to: 'graphql#execute', as: :api, via: [:get, :post]

  devise_for :users, controllers: { omniauth_callbacks: 'session' }

  devise_scope :user do
    get '/users/auth/:provider/setup', :to => 'session#setup'
    get '/sign-in' => 'session#new', as: :login
    get '/sign-out' => 'session#destroy', as: :logout
    get '/setup' => 'session#first_setup', as: :first_setup
    get '/failure' => 'session#failure', as: :failure_session
  end

  post '/webhook/:id' => 'webhook#github', as: :webhook

  get '*path', to: 'home#index', constraints: lambda { |req| req.path.exclude? 'rails/active_storage' }
  root 'home#index'
end
