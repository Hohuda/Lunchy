FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end
end

def create_user_with_orders(orders_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:order, orders_count, user: user)
  end
end