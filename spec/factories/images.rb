# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    sequence(:name) { |index| "image: #{index}" }
    sequence(:base) { |_index| 'ruby:latest' }

    trait :with_project do
      project
    end

    trait :with_steps do
      transient do
        steps { 1 }
      end

      before(:create) do |image, evaluator|
        steps = evaluator.steps.times
        image.build_script = steps.map { |index| "normal command: #{index}" }.join("\n")
        image.setup_script = steps.map { |index| "after build: #{index}" }.join("\n")
      end
    end
  end
end
