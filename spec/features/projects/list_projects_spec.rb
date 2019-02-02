require 'rails_helper'

RSpec.feature 'Listing projects' do
  scenario 'user see all projects' do
    projects = create_list(:project, 10)
    sign_in_developer
    visit '/projects'

    projects.each do |project|
      expect(page).to have_text(project.name)
    end
  end

  scenario 'there is no projects' do
    sign_in_developer
    visit '/projects'
    expect(page).to have_text("Currently you don't have any projects")
  end

  scenario 'can add project' do
    expect(Github::FetchRepositories).to receive(:call).and_return(double('Success', success: {}))
    sign_in_developer
    visit '/projects'
    find('#add_project').click
    expect(page).to have_text('New project')
  end

  scenario 'guest is moved to sign-in page' do
    projects = create_list(:project, 10)
    sign_out
    visit '/projects'
    expect(page).to have_text(/Sign in with github/i)
  end

  context 'infinity scroll' do
    let!(:projects) { create_list(:project, 50)}
    before do
      sign_in_developer
      visit '/projects'
    end

    scenario 'after page load, there should be only 25 projects visible' do
      projects[0..24].each { |project| expect(page).to have_text(project.name) }
      projects[25..-1].each { |project| expect(page).not_to have_text(project.name) }
    end

    scenario 'after scroll down, another 25 projects should appear' do
      expect(page).to have_text(projects[0].name)
      page.execute_script 'window.scrollBy(0,10000)'
      projects[25..-1].each { |project| expect(page).to have_text(project.name) }
    end
  end
end
