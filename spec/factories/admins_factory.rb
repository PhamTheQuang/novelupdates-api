FactoryGirl.define do
  factory :admin do
    sequence(:admin) { |n| "admin_#{n}@mail.com" }
  end
end
