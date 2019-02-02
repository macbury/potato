require 'rails_helper'

RSpec.feature 'Edit project images' do
  let(:project) { create(:project, :with_image) }
  before do
    sign_in_developer
    visit "/projects/#{project.id}/edit"
  end

  let(:build_script_content) { 'build ' + Time.now.to_s }
  let(:setup_script_content) { 'setup' + Time.now.to_s }
  let(:caches_content) { "\nabc\ndir2\nnode_mod\n" }

  let(:image) { project.images.first }

  scenario 'can edit first image' do
    find('p', text: image.name).click
    expect(page).to have_content(image.name)
    expect(page).to have_content('random_dir')
    find('#image-build-script textarea').fill_in with: build_script_content
    find('#image-setup-script textarea').fill_in with: setup_script_content
    find('#image-caches textarea').fill_in with: caches_content

    click_on 'Save changes'
    expect(page).to have_content('Image saved successful')
    image.reload
    expect(image.build_script).to eq(build_script_content)
    expect(image.setup_script).to eq(setup_script_content)
    expect(image.caches).to eq(['random_dir', 'abc', 'dir2', 'node_mod', 'random_dir'])
  end

end
