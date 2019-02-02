require 'rails_helper'

RSpec.feature 'Creating project' do
  let(:result) { double('Result', success: nil, failure: nil) }
  let(:project) { create(:project) }
  let(:github_response) do
    [
      {
        id: 2,
        name: 'alonetone',
        ssh_url: 'git@github.com:macbury/alonetone.git',
        owner: {
          avatar_url: 'https://avatars0.githubusercontent.com/u/110908?v=4',
          login: 'macbury'
        }
      }, {
        id: 1,
        name: 'amistad',
        ssh_url: 'git@github.com:macbury/amistad.git',
        owner: {
          avatar_url: 'https://avatars0.githubusercontent.com/u/110908?v=4',
          login: 'macbury'
        }
      }
    ]
  end

  before do
    allow_any_instance_of(CreateProject).to receive(:call).and_yield(result)
    expect(Github::FetchRepositories).to receive(:call).and_return(double('Success', success: github_response))
    sign_in_developer
    visit '/projects/new'
  end

  scenario 'user can cancel this form' do
    click_on 'Cancel'
    expect(current_path).to eq('/projects')
  end

  scenario 'user enters invalid data and clicks create project' do
    expect(result).to receive(:failure).and_yield('Validation error here')
    find('#repository-select').click
    find('#repository-select div[role=option]', text: 'macbury/amistad').click

    expect(find('#project-name').value).to eq('amistad')
    click_on 'Create project'
    expect(page).to have_text('Validation error here')
  end

  scenario 'user enters valid data and clicks create project' do
    expect(result).to receive(:success).and_yield(project)
    expect(page).to have_text('Connect Your GitHub Repository')

    find('#repository-select').click
    find('#repository-select div[role=option]', text: 'macbury/amistad').click

    expect(find('#project-name').value).to eq('amistad')
    click_on 'Create project'
    expect(page).to have_text('Created new project!')
  end

  scenario 'user enters name and then select repo' do
    fill_in 'project-name', with: 'yolo'
    find('#repository-select').click
    find('#repository-select div[role=option]', text: 'macbury/amistad').click

    expect(find('#project-name').value).to eq('yolo')
  end
end
