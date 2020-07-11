FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end

  factory :admin, parent: :user do
    admin { true }
  end
end
