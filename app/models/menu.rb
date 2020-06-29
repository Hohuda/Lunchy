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
    victuals.joins(:categories).where("categories.id = ?", Category.first_course.id)
  end

  # Returns main course victuals from menu
  def main_courses
    victuals.joins(:categories).where("categories.id = ?", Category.main_course.id)
  end

  # Returns drink victuals from menu
  def drinks
    victuals.joins(:categories).where("categories.id = ?", Category.drink.id)
  end

  # Changes victuals in menu
  def change_victuals(ids)
    if ids.is_a? Enumerable
      ids.filter!{|i| i unless i.blank?}
      comparison = (categories.ids <=> ids)
      if comparison == 1
        diff = categories.ids - ids
        remove_victuals Victual.find(diff)
      elsif comparison == -1
        diff = ids - categories.ids
        add_victuals Victual.find(diff)
      end
    else
      false                    #<<<<<------Rework for exception probably
    end
  end

  # Returnes menus with specified created date 
  def self.search_by_date(date)
    date = Date.parse(date)
    Menu.where(created_at: date.beginning_of_day..date.end_of_day)
  end

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
          false
        else
          victuals << victual
        end
      else
        puts "Argument type mismatch"
        false
      end
    end
    
    # Removes one victual from menu
    def remove_victual(victual)
      if victual.is_a? Victual
        if victuals.include?(victual)
          victuals.delete victual
        else
          puts 'No such victual'
          false
        end
      else
        puts "Argument type mismatch"
        false
      end
    end
  
end
