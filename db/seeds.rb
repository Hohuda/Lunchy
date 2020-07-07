# Seeding categories
categories_names = ["First course", "Main course", "Drink"]

categories_names.each do |name|
  Category.create name: name
end

# Caching categories
first_course = Category.first_course
main_course = Category.main_course
drink = Category.drink

puts "Start creating foods"
# Seeding victuals
# Seeding first_courses victuals
50.times do
  food_name = Faker::Food.dish
  food_price = Random.rand(2.00..10.00).round(2)
  vic = Victual.create(name: food_name, price: food_price) 
  if Random.rand(1..2) == 1
    vic.categories << first_course
  else
    vic.categories << main_course
  end
end

puts "Start create drinks"
25.times do
  drink_name = Faker::Beer.style
  drink_price = Random.rand(2.00..5.00).round(2)
  vic = Victual.create(name: drink_name, price: drink_price)
  vic.categories << drink
end

# Seeding menu
# Seed today's menu
puts "Start creating menus"
4.times do
  menu_name = Faker::Restaurant.type
  Menu.create(name: menu_name)
end
# Seed other menus
25.times do
  menu_name = Faker::Restaurant.type
  days_ago = Random.rand(0..50)
  Menu.create(name: menu_name, created_at: Time.now - days_ago.day)
end

# Add some victuals to menus
puts "Start adding victuals to menus"

first_courses_ids = first_course.victual_ids
main_courses_ids = main_course.victual_ids
drinks_ids = drink.victual_ids

Menu.find_each do |menu|
  firsts_amount = Random.rand(1..5)
  mains_amount = Random.rand(1..5)
  drinks_amount = Random.rand(1..5)
  menu.set_victuals first_courses_ids.shuffle.take(firsts_amount)
  menu.set_victuals main_courses_ids.shuffle.take(mains_amount)
  menu.set_victuals drinks_ids.shuffle.take(drinks_amount)
end

# Seeding users
puts "Start creating users"
# Seeding admin
User.create name: 'Anatoly', email: 'anatoly@gmail.com', password: 'password', password_confirmation: 'password'

# Seeding other account
40.times do |n|
  user_name = Faker::Name.name
  User.create name: user_name, email: "email#{n}@gmail.com", password: 'password'
end

# Seeding user orders
puts "Start creating orders"
User.find_each do |user|
  Menu.all.each do |menu|
    amount = Random.rand(1..2)
    amount.times do
      user.orders.create menu: menu, created_at: menu.created_at
    end
  end
end

# Seeding ordered victuals
puts "Start adding victuals to orders"
Order.find_each do |order|                                 # <<<<<<<<<<<<<<------------ Change this to seed faster.
  ids = order.menu.victual_ids
  amount = Random.rand(1..ids.count)
  order.set_victuals ids.shuffle.take(amount)
end