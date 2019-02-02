require 'rails_helper'

RSpec.feature 'Show project' do
  let!(:project) { create(:project) }
  before do 
    sign_in_developer
    visit "/projects/#{project.id}"
  end

  scenario 'user can see project name' do
    expect(page).to have_text(project.name)
  end

  scenario 'user can see project repo' do
    expect(page).to have_text(project.git)
  end

  scenario 'user can see information about empty builds' do
    expect(page).to have_text('Trigger your first build!')
  end

  scenario 'can trigger build' do
    build = create(:build, :with_project)
    allow_any_instance_of(Builds::Create).to receive(:call).and_return(build)
    find('#trigger_build').click
    expect(page).to have_text("##{build.number}.")
    expect(page).to have_text(build.message)
  end

  context 'there are builds' do
    let(:build_count) { 30 }
    let!(:project) { create(:project, :with_image, :with_builds, build_count: build_count) }
    let(:builds) { project.builds }
    let(:build) { builds.last }

    scenario 'there is a list with builds' do
      expect(page).to have_text(build.message)
      expect(page).to have_text(build.branch)
      expect(page).to have_text(build.sha[0..7])
      (16..30).each { |build_no| expect(page).to have_text("##{build_no}") }
    end

    scenario 'builds are updated at runtime' do
      within "#build_#{build.id}" do
        expect(page).to have_text('pending')
        build.failed!
        PotatoSchema.subscriptions.trigger('build', {}, build)
        expect(page).to have_text('failed')

        build.running!
        PotatoSchema.subscriptions.trigger('build', {}, build)
        expect(page).to have_text('running')

        build.done!
        PotatoSchema.subscriptions.trigger('build', {}, build)
        expect(page).to have_text('done')
      end
    end

    scenario 'scrolling bottom will load more builds' do
      (16..30).each { |build_no| expect(page).to have_text("##{build_no}") }
      page.execute_script 'window.scrollBy(0,10000)'
      (1..15).each { |build_no| expect(page).to have_text("##{build_no}") }
    end
  end
end
