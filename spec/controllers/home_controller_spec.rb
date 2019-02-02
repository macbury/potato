require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    it 'redirect to setup path if there is any super admin' do
      get :index
      expect(response).to redirect_to(first_setup_path)
    end

    it 'redirect to login path if user not signed in' do
      create(:user, :as_superadmin)
      get :index
      expect(response).to redirect_to(login_path)
    end

    it 'returns http success for logged in user' do
      sign_in(create(:user, :as_developer))
      get :index
      expect(response).to be_successful
    end
  end
end
