FactoryBot.define do
  factory :order do
    association :user, :menu
  end
end

def create_order_with_victuals(user:, menu:, victuals_amount: menu.menu_items.count)
  order = create(:order, user: user, menu: menu)
  menu_items_count = menu.menu_items.count
  if victuals_amount > 0 && victuals_amount <= menu_items_count
    order.menu_items << menu.menu_items.take(victuals_amount)
  elsif victuals_amount > menu_items_count
    order.menu_items << menu.menu_items
  end
  order
end
