FactoryBot.define do
  factory :menu do
    name { Faker::Restaurant.type }
  end

  trait :with_victual do
    after(:create) do |menu|
      menu.victuals << create(:victual)
    end
  end
end
