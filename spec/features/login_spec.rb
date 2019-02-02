require 'rails_helper'

RSpec.feature 'Sign user', type: :feature do
  scenario 'user clicks on sign in using github' do
    visit '/sign-in'

    click_on 'Sign in with github'
    expect(URI.parse(current_url).host).to eq 'github.com'
  end
end