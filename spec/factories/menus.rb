FactoryBot.define do
  factory :menu do
    name { Faker::Restaurant.type }
  end
end

def create_menu_with_victuals(victuals_count: 5)
  menu = create(:menu)
  create_list(:victual, victuals_count) { |vic| menu.victuals << vic }
  menu
end
