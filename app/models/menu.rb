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
  # Adds one victual to menu
  def add_victual(victual)
    if victual.is_a? Victual
      if victuals.include? victual
        puts "#{Victual} is already exists"
        return false 
      end
      victuals << victual
    else
      return false
    end
  end

  # Adds victual/victuals to menu
  def add_victuals(victual_collection)
    if victual_collection.is_a? Enumerable
      if victual_collection.count > 1
        victual_collection.each do |victual|
          add_victual(victual)
        end
      else 
        add_victual(victual)
      end
    else 
      puts 'Argument is not enumerable'
      return false 
    end
  end

  # Deleting victuals from menu
  # Deletes victual from menu
  def remove_victual(victual)
    if victual.is_a? Victual
      if victuals.include? victual
        victuals.delete victual
        puts "Victual #{victual} deleted"
        return true
      else 
        puts "There is no such victual"
        return false
      end
    else
      puts "#{victual} is not of Victual class"
      return false
    end
  end

  # Deletes collection of victuals from menu
  def remove_victuals(victual_collection)
    if victual_collection.is_a? Enumerable
      if victual_collection.count > 1
        victual_collection.each do |victual|
          remove_victual victual
        end
      elsif victual_collection
        remove_victual victual_collection
      end
    else 
      puts "Argument is not enumerable"
      return false
    end
  end

end
