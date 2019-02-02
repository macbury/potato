require 'rails_helper'

RSpec.feature 'After visit show build page' do
  let!(:build) { create(:build, :with_project, :is_running, branch: 'test', sha: 'testing') }
  let(:project) { build.project }
  let(:image_steps) { build.steps.for_images }
  let(:pipeline_steps) { build.steps.for_pipelines }

  before do 
    sign_in_developer
    visit "/projects/#{project.id}/builds/#{build.id}"
  end

  scenario 'user can trigger rebuild' do
    next_build = create(:build, :with_project)
    expect(Builds::Create).to receive(:new).with({
      project: kind_of(Project),
      branch: 'test',
      sha: 'testing'
    }).and_return(double('Builds::Create', call: next_build))

    find('#trigger_build').click
    expect(page).to have_text("##{next_build.number}.")
    expect(page).to have_text(next_build.message)
  end

  scenario 'user should see a list of image steps' do
    expect(page).to have_content(build.images.first.name)
    image_steps.each do |step|
      expect(page).to have_content(step.command)
    end
  end

  scenario 'user should see a list of pipeline steps' do
    expect(page).to have_content(build.pipelines.first.name)
    pipeline_steps.each do |step|
      expect(page).to have_content(step.command)
    end
  end

  scenario 'builds are updated at runtime' do
    expect(page).to have_text('pending')
    build.failed!
    PotatoSchema.subscriptions.trigger('build', { id: build.id }, build)
    expect(page).to have_text('failed')

    build.running!
    PotatoSchema.subscriptions.trigger('build', { id: build.id }, build)
    expect(page).to have_text('running')

    build.done!
    PotatoSchema.subscriptions.trigger('build', { id: build.id }, build)
    expect(page).to have_text('done')
  end

  scenario 'steps are updated at runtime' do
    expect(page).to have_text(build.message)
    step = image_steps.first

    step.running!
    PotatoSchema.subscriptions.trigger('build', { id: build.id }, build)
    expect(page).to have_css("#step_#{step.id}_running")

    step.done!
    PotatoSchema.subscriptions.trigger('build', { id: build.id }, build)
    expect(page).to have_css("#step_#{step.id}_done")

    step.failed!
    PotatoSchema.subscriptions.trigger('build', { id: build.id }, build)
    expect(page).to have_css("#step_#{step.id}_failed")
  end

  scenario 'user can expand step output' do
    step = image_steps.first
    find("#step_#{step.id}_pending").click
    expect(page).to have_content('Waiting for output...')
  end

  scenario 'output is updated at runtime' do
    step = image_steps.first
    find("#step_#{step.id}_pending").click
    expect(page).to have_content('Waiting for output...')
    PotatoSchema.subscriptions.trigger('stepOutput', { id: step.id }, { output: ["Line number first\n"] })
    expect(page).to have_content('Line number first')
    PotatoSchema.subscriptions.trigger('stepOutput', { id: step.id }, { output: ["Line number second\n"] })
    expect(page).to have_content("Line number first\nLine number second")
  end
end
