class Category < ApplicationRecord
  default_scope { order('categories.name ASC')}

  has_many :category_items, dependent: :destroy
  has_many :victuals, through: :category_items

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :first_course, -> { find_by(name: 'First course') }
  scope :main_course, -> { find_by(name: 'Main course') }
  scope :drink, -> { find_by(name: 'Drink') }

  def self.remove_by_id(*ids)
    ids_to_remove = ids.flatten.select(&:present?).map(&:to_s).uniq
    Category.delete(ids_to_remove)
  end
end
