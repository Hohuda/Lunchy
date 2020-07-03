class Victual < ApplicationRecord

  has_many :category_items, dependent: :destroy
  has_many :categories, through: :category_items

  validates :name, presence: true, uniqueness: { scope: :price }
  validates :price, presence: true, numericality: {
    greater_than_or_equal_to: 0.1,
    less_than_or_equal_to: 100
  }

  mount_uploader :avatar, AvatarUploader

  # Sets categories specified by id
  def set_categories(*ids)
    ids.filter! { |i| i unless i.blank? }
    comp = (categories.ids <=> ids)
    if comp > 0
      diff = categories.ids - ids
      categories.delete(Category.find(diff))
    elsif comp < 0
      diff = ids - categories.ids
      categories << Category.find(diff)
    end
  end

  # # Adds many categories to victual
  # def add_categories(*args)
  #   categories << args
  # end

  # # Removes many categories from victual
  # def remove_categories(*args)
  #   categories.delete(args)
  # end
end
