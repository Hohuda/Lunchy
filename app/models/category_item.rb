class CategoryItem < ApplicationRecord

  belongs_to :victual
  belongs_to :category

  validates :victual_id, presence: true
  validates :category_id, presence: true

end
