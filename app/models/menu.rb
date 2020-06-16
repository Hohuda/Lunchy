class Menu < ApplicationRecord
    
  has_many :orders
  has_many :menu_items
  has_many :victuals, through: :menu_items 
  has_many :categories, through: :victuals

end
