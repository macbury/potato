# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |index| "email#{index}@test.local" }
    token { 'abcde' }
    sequence(:github_id) { |index| index }
    sequence(:name) { |index| "user#{index}" }

    trait :as_superadmin do
      role { :superadmin }
      after(:create) { |user, _evaluator| user.unlock_access! }
    end

    trait :as_developer do
      after(:create) { |user, _evaluator| user.unlock_access! }
    end
  end
end