FactoryBot.define do
  factory :victual do
    name { Faker::Food.dish }
    price { Random.rand(2.00..10.00).round(2) }

    after_create do |vic|
      vic.categories << Category.all.shuffle.take
    end
  end
end