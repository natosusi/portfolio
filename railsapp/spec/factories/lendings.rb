FactoryBot.define do
  factory :lending do
    association :book
    association :user
    schedule_date { Date.current }
  end
end
