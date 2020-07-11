FactoryBot.define do
  factory :menu do
    name { Faker::Restaurant.type }
  end
end
