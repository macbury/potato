# frozen_string_literal: true

FactoryBot.define do
  factory :build do
    project
    sha { '7638417db6d59f3c431d3e1f261cc637155684cd' }
    message { 'added readme, because im a good github citizen' }
    branch { 'master' }
    author_name { 'yolo' }
    author_github_id { 'yolo@test.local' }

    trait :with_project do
      transient do
        steps { 1 }
      end
      before(:create) do |build, evaluator|
        pipeline = create(:pipeline, :with_image, :with_steps, steps: evaluator.steps)
        build.project_id = pipeline.project_id
        build.project.ssh_keys.create(name: 'pipeline')
      end
    end

    trait :is_running do
      after(:create) { |build, _evaluator| Builds::CopySteps.new(build).call }
    end
  end
end
