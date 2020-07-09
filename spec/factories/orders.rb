FactoryBot.define do
  factory :order do
    association :user, :menu
  end

  trait :with_victuals do
    after_create do |order|
      order.set_victuals order.menu.victual_ids
    end
  end
end