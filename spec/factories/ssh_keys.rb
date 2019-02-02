# frozen_string_literal: true

FactoryBot.define do
  factory :ssh_key do
    project
    sequence(:name) { |index| "key#{index}" }
  end
end
