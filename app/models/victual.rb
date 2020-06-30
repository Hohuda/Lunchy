class Victual < ApplicationRecord

  has_many :category_items
  has_many :categories, through: :category_items

  validates :name, presence: true, uniqueness: { scope: :price}
  validates :price, presence: true, numericality: { 
    greater_than_or_equal_to: 0.1,
    less_than_or_equal_to: 100
  }

  mount_uploader :avatar, AvatarUploader

  # Scopes
  # Returns first course victuals
  def self.first_courses
    joins(:categories).where("categories.id = ?", Category.first_course.id)
  end

  # Returns main course victuals
  def self.main_courses
    joins(:categories).where("categories.id = ?", Category.main_course.id)
  end

  # Returns drink victuals
  def self.drinks
    joins(:categories).where("categories.id = ?", Category.drink.id)
  end

  # Checks is victual first course
  def is_first_course? 
    if categories.include?(Category.first_course)
      return true
    else 
      return false
    end
  end

  # Checks is victual main course
  def is_main_course? 
    if categories.include?(Category.main_course)
      return true
    else 
      return false
    end
  end
  
  # Checks is victual drink
  def is_drink? 
    if categories.include?(Category.drink)
      return true
    else 
      return false
    end
  end
  

  # Changes categories
  def change_categories(ids)
    if ids.is_a? Enumerable
      ids.filter!{|i| i unless i.blank?}
      comparison = (categories.ids <=> ids)
      if comparison == 1
        diff = categories.ids - ids
        remove_categories Category.find(diff)
      elsif comparison == -1
        diff = ids - categories.ids
        add_categories Category.find(diff)
      end
    else
      return false                    #<<<<<------Rework for exception probably
    end
  end


  # Adds many categories to victual
  def add_categories(collection)
    if collection.is_a? Enumerable
      collection.each do |category|
        add_category category
      end
    else
      add_category collection
    end
  end

  # Removes many categories from victual
  def remove_categories(collection)
    if collection.is_a? Enumerable
      collection.each do |category|
        remove_category category
      end
    else
      remove_category collection
    end
  end
  
  # Adding categories to created victuals
  def add_category(category)
    if category.is_a? Category
      if categories.include? category
        return false
      else
        categories << category
      end
    else
      return false
    end
  end
  
  # Deleting categories from created victuals
  def remove_category(category)
    if category.is_a? Category
      if categories.include? category
        categories.delete category
      else
        return false
      end
    else
      return false
    end
  end
  
  # Add first_courses category
  def to_first_courses
    add_category Category.first_course
  end
  
  # Add main_courses category
  def to_main_courses
    add_category Category.main_course
  end
  
  # Add drinks category
  def to_drinks
    add_category Category.drink
  end
end
