FactoryBot.define do
  factory :order do
    association :user, :menu
  end
end