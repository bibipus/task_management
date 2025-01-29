# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { Faker::Lorem.sentence }
    position { rand(1..100) }
    association :user
  end
end