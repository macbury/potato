# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |index| "project: #{index}" }
    sequence(:repository_id) { |index| index }
    sequence(:git) { |index| "git@repo:som#{index}.git" }

    trait :with_image do
      after(:create) do |project, _evaluator|
        image = create(:image, project: project, caches: ['random_dir'])
        create(:pipeline, image: image, project: project)
      end
    end

    trait :with_builds do
      transient do
        build_count { 5 }
      end
      after(:create) do |project, evaluator|
        create_list(:build, evaluator.build_count, project: project)
      end
    end
  end
end
