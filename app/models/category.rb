class Category < ApplicationRecord

  has_many :category_items
  has_many :victuals, through: :category_items

  validates :name, presence: true, uniqueness: { case_sensitive: false}

  def self.first_courses
    find_by name: 'first_courses'
  end

  def self.main_courses
    find_by name: 'main_courses'
  end
  
  def self.drinks
    find_by name: 'drinks'
  end

end
