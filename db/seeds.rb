# Seeding categories
categories_names = %w[first_courses main_courses drinks]

categories_names.each do |name|
  Category.create name: name
end

# Seeding victuals
# Seeding first_courses victuals
soups_names = ['Borsh', 'Solyanka', 'Shi', 'Chicken soup', 'Tomato soup']

soups_names.each do |name|
  soup = Victual.create name: name, price: 1.99
  soup.to_first_courses
end

# Seeding main_courses victuals
mains_names = ['Seared Scallops with Brown Butter and Lemon Pan Sauce', 
               'Pork Chops with Fig and Grape Agrodolce', 
               'Cauliflower Bolognese',
               'Chicken Stew with Potatoes and Radishes']

mains_names.each do |name|
  main = Victual.create name: name, price: 2.99
  main.to_main_courses
end

# Seeding drinks victuals
drinks_names = ['Juice', 'Green Tea', 'Black Tea', 'Coffee', 'Water', 'Soda']

drinks_names.each do |name|
  drink = Victual.create name: name, price: 0.99
  drink.to_drinks
end

# Seeding menu
# Seed today's menu
custom_menu = Menu.create name: 'A lot of different meals.'

# Seed yesterday's menu
yest_menu = Menu.create name: 'No oisters today.', created_at: 1.day.ago

# Add some victuals to menus
Victual.first_courses.each {|victual| custom_menu.add_victual(victual)}
Victual.main_courses.each {|victual| custom_menu.add_victual(victual)}
Victual.drinks.each {|victual| custom_menu.add_victual(victual)}


# Seeding user
user = User.create name: 'Anatoly', email: 'anatoly@gmail.com', password: 'password', password_confirmation: 'password'

# Seeding user orders
order = user.orders.build( { menu: custom_menu } )
order.add_items order.menu.victuals.first

# yest_order = user.orders.build( { menu: yest_menu, created_at: yest_menu.created_at + 4.hours})
# yest_order.save

# Seeding ordered victuals
