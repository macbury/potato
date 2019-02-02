require 'rails_helper'

RSpec.describe SessionController, type: :controller do
  describe "GET #first_setup" do
    it 'redirect to root_path if super admin exists already', setup_complete: true do
      get :first_setup
      expect(response).to redirect_to(root_path)
    end

    it 'redirect to github authorize' do
      get :first_setup
      expect(response).to redirect_to('/users/auth/github?first_setup=true')
    end
  end
end
