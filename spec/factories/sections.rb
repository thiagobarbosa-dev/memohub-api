FactoryBot.define do
  factory :section do
    sequence(:title) { |n| "Section #{n}" }
    association :notebook
  end
end