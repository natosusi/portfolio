FactoryBot.define do
  factory :review do
    association :book
    association :user
    
    title { Faker::Lorem.word }
    comment { Faker::Lorem.sentences }
  end
end
