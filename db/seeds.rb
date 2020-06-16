# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seeding categories
categories_names = %w[first_courses main_courses drinks]

categories_names.each do |name|
  category = Category.new name: name
  category.save
end

# Seeding victuals
# Seeding first_courses victuals
soups_names = ['Borsh', 'Solyanka', 'Shi', 'Chicken soup', 'Tomato soup']
first_courses = Category.find_by name: 'first_courses'
soups_names.each do |name|
  soup = Victual.new name: name, price: 1.99, category: first_courses
  soup.save
end

# Seeding main_courses victuals
mains_names = ['Seared Scallops with Brown Butter and Lemon Pan Sauce', 
               'Pork Chops with Fig and Grape Agrodolce', 
               'Cauliflower Bolognese',
               'Chicken Stew with Potatoes and Radishes']
main_courses = Category.find_by name: 'main_courses'              
mains_names.each do |name|
  meal = Victual.new name: name, price: 5.59, category: first_courses
  meal.save
end

# Seeding drinks victuals
drinks_names = ['Juice', 'Green Tea', 'Black Tea', 'Coffee', 'Water', 'Soda']
drinks = Category.find_by name: 'drinks'
drinks_names.each do |name|
  drink = Victual.new name: name, price: 0.75, category: first_courses
  drink.save
end

# Seeding menu
# Seed today's menu
custom_menu = Menu.new name: 'A lot of different meals.'
custom_menu.save

# Seed yesterday's menu
yest_menu = Menu.new name: 'No oisters today.', created_at: 1.day.ago
yest_menu.save

# Add some victuals to menus
Category.all.each do |category|
  menu_victuals = []
  Victual.all.each do |victual|
    menu_victuals << victual if victual.category == category
  end
  (0..(menu_victuals.count - 1)).each do |n|
    if n < menu_victuals.count/2
      custom_menu.victuals << menu_victuals[n]
    else
      yest_menu.victuals << menu_victuals[n]
    end
  end
end

# Seeding user
user = User.new name: 'Anatoly', email: 'anatoly@gmail.com', password: 'password', password_confirmation: 'password'
user.save

# Seeding user orders
order = user.orders.build( { menu: custom_menu } )
order.save

# yest_order = user.orders.build( { menu: yest_menu, created_at: yest_menu.created_at + 4.hours})
# yest_order.save

# Seeding ordered victuals
