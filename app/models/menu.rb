class Menu < ApplicationRecord
    
  has_many :orders
  has_many :menu_items
  has_many :victuals, through: :menu_items 
  has_many :categories, through: :victuals

  # Default descended by created_at index, last created first in table
  default_scope -> { order(created_at: :desc) }

  # Scopes 
  # Returns menus created today
  def self.today_menus
    all.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end
  
  # Returns first course victuals from menu
  def first_courses
    victuals.joins(:categories).where("categories.id = ?", Category.first_courses.id)
  end

  # Returns main course victuals from menu
  def main_courses
    victuals.joins(:categories).where("categories.id = ?", Category.main_courses.id)
  end

  # Returns drink victuals from menu
  def drinks
    victuals.joins(:categories).where("categories.id = ?", Category.drinks.id)
  end

  # Adding victuals to menu
  
  # Adds victual/victuals to menu
  def add_victuals(collection)
    if collection.is_a? Enumerable
      collection.each do |victual|
        add_victual victual
      end
    else
      add_victual collection
    end
  end
  
  # Deletes victual/victuals from menu
  def remove_victuals(collection)
    if collection.is_a? Enumerable
      collection.each do |victual|
        remove_victual victual
      end
    else
      remove_victual collection
    end
  end
  
  private 
  
    # Adds one victual to menu
    def add_victual(victual)
      if victual.is_a? Victual
        if victuals.include? victual
          puts "This victual is already exist"
          return false
        else
          victuals << victual
        end
      else
        puts "Argument type mismatch"
        return false
      end
    end
    
    # Removes one victual from menu
    def remove_victual(victual)
      if victual.is_a? Victual
        if victuals.include?(victual)
          victuals.delete victual
        else
          puts 'No such victual'
          return false
        end
      else
        puts "Argument type mismatch"
        return false
      end
    end
  
end
