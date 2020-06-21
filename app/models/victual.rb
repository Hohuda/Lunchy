class Victual < ApplicationRecord

  has_many :category_items
  has_many :categories, through: :category_items

  validates :name, presence: true, uniqueness: { case_sensitive: false}
  validates :price, presence: true

  # Scopes
  # Returns first course victuals
  def self.first_courses
    joins(:categories).where("categories.id = ?", Category.first_courses.id)
  end

  # Returns main course victuals
  def self.main_courses
    joins(:categories).where("categories.id = ?", Category.main_courses.id)
  end

  # Returns drink victuals
  def self.drinks
    joins(:categories).where("categories.id = ?", Category.drinks.id)
  end

  # Checks is victual first course
  def is_first_course? 
    if categories.include?(Category.first_courses)
      return true
    else 
      return false
    end
  end

  # Checks is victual main course
  def is_main_course? 
    if categories.include?(Category.main_courses)
      return true
    else 
      return false
    end
  end

  # Checks is victual drink
  def is_drink? 
    if categories.include?(Category.drinks)
      return true
    else 
      return false
    end
  end

  # Adding categories to created victuals
  def add_category(category)
    if category.is_a? Category
      categories << category
      return true
    else
      return false
    end
  end

  # Deleting categories from created victuals
  def remove_from_category(category)
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
    add_category Category.first_courses
  end

  # Add main_courses category
  def to_main_courses
    add_category Category.main_courses
  end

  # Add drinks category
  def to_drinks
    add_category Category.drinks
  end
end
