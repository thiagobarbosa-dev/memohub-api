FactoryBot.define do
  factory :notebook do
    sequence(:title) { |n| "Notebook #{n}" }
    association :user
  end
end