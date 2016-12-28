FactoryGirl.define do
  factory :group do
    title { Faker::Lorem.sentence }
    sequence(:slug) { |n| "group-#{n}" }
  end
end
