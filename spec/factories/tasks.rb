# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    is_done { false }
    association :user
    association :project

    trait :done do
      is_done { true }
    end
  end
end