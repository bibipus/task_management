FactoryBot.define do
  factory :tag do
    title { Faker::Lorem.word }
    association :user
  end
end