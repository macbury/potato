module DeviseControllerHelpers
  def sign_in(user = double('user'))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end

module DeviseFeatureHelpers
  def sign_in_developer(*args)
    create(:user, :as_superadmin)
    sign_in(:user, :as_developer, *args)
  end

  def sign_out
    create(:user, :as_superadmin)
  end

  def sign_in(*args)
    create(:user, :as_superadmin)
    user = create(*args)
    login_as(user, scope: :user, run_callbacks: false)
    user
  end
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include DeviseControllerHelpers, type: :controller
  config.include DeviseFeatureHelpers, type: :feature
  config.include Warden::Test::Helpers, type: :feature

  config.before(:each, type: :controller) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  config.before(:each, setup_complete: true) do
    create(:user, :as_superadmin)
  end

  config.after :each, type: :controller do
    Warden.test_reset! if Warden.respond_to?(:test_reset!)
  end
end
