FactoryBot.define do
  factory :notification do
    association :user
    association :lending
    action_type { Faker::Number.between(from:1, to:3) }
  end
end
