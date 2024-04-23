FactoryBot.define do
  factory :page do
    sequence(:title) { |n| "Page #{n}" }
    content { 'Lorem ipsum dolor sit amet' }
    association :section
  end
end