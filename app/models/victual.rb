class Victual < ApplicationRecord
  has_many :category_items, dependent: :destroy
  has_many :categories, through: :category_items

  validates :name, presence: true, uniqueness: { scope: :price }
  validates :price, presence: true, numericality: {
    greater_than_or_equal_to: 0.1,
    less_than_or_equal_to: 100
  }

  mount_uploader :avatar, AvatarUploader

  include SetAssociations
  create_set_association_method_for(Category)
end
