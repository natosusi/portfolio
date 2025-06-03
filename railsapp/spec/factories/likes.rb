FactoryBot.define do
  factory :like do
    association :book
    association :user
    
  end
end
