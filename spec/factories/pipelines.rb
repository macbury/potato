# frozen_string_literal: true

FactoryBot.define do
  factory :pipeline do
    sequence(:name) { |index| "pipeline: #{index}" }

    trait :with_image do
      transient do
        steps { 1 }
      end
      before(:create) do |pipeline, evaluator|
        pipeline.image = create(:image, :with_project, :with_steps, steps: evaluator.steps)
        pipeline.project = pipeline.image.project
      end
    end

    trait :with_steps do
      transient do
        steps { 1 }
      end
      before(:create) do |pipeline, evaluator|
        steps = evaluator.steps.times
        pipeline.script = steps.map { |index| "command: #{index}" }.join("\n")
      end
    end
  end
end
