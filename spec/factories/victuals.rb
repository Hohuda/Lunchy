FactoryBot.define do
  factory :victual do
    name { Faker::Food.dish }
    price { Random.rand(2.00..10.00).round(2) }
  end
end

def create_victual_with_categories(categories_count: 3)
  victual = create(:victual)
  create_list(:category, categories_count) do |category|
    victual.categories << category
  end
  victual
end
