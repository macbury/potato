require 'rails_helper'

RSpec.feature 'Sign out', type: :feature do
  scenario 'user clicks logout' do
    sign_in_developer
    visit '/'

    find('#user-button').click
    find('#logout-button').click
    expect(page).to have_content('Signed out successfully.')
  end
end