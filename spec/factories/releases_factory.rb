FactoryGirl.define do
  factory :release do
    title { Faker::Lorem.word }
    released_at { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    sequence(:slug) { |n| "release-#{n}" }
    url { "#{ENV['base_url']}/extnu/#{slug}" }
    series
    group
  end
end
