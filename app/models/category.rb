class Category < ApplicationRecord
  has_many :category_items
  has_many :victuals, through: :category_items

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :first_course, -> { find_by(name: 'First course') }
  scope :main_course, -> { find_by(name: 'Main course') }
  scope :drink, -> { find_by(name: 'Drink') }
end
