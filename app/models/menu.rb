class Menu < ApplicationRecord
  # Default descended by created_at index, last created first in table
  default_scope -> { order(created_at: :desc) }
    
  has_many :orders
  has_many :menu_items, dependent: :destroy
  has_many :victuals, through: :menu_items 
  has_many :categories, through: :victuals

  # Scopes 
  scope :today_menus, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }
  
  include SetAssociations
  create_set_association_method_for(Victual)

  # Returnes menus with specified created date 
  def self.search_by_date(date)
    date = Date.parse(date)
    where(created_at: date.beginning_of_day..date.end_of_day)
  end
end
