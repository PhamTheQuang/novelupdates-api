FactoryGirl.define do
  factory :series do
    title { Faker::Lorem.sentence }
    sequence(:slug) { |n| "series-#{n}" }
  end
end
