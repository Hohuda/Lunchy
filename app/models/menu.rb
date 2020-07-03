class Menu < ApplicationRecord
  # Default descended by created_at index, last created first in table
  default_scope -> { order(created_at: :desc) }
    
  has_many :orders
  has_many :menu_items, dependent: :destroy
  has_many :victuals, through: :menu_items 
  has_many :categories, through: :victuals

  # Scopes 
  scope :today_menus, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }
  
  # Changes victuals in menu
  def set_victuals(ids)
    ids.filter! { |i| i unless i.blank? }
    comp = (categories.ids <=> ids)
    if comp > 0
      diff = categories.ids - ids
      victuals.delete(Victual.find(diff))
    elsif comp < 0
      diff = ids - categories.ids
      victuals << Victual.find(diff)
    end
  end

  # Returnes menus with specified created date 
  def self.search_by_date(date)
    date = Date.parse(date)
    where(created_at: date.beginning_of_day..date.end_of_day)
  end
end
