class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :victual
  has_many :order_items, dependent: :destroy

  validates :menu_id, presence: true
  validates :victual_id, presence: true
  validates :menu_id, uniqueness: { scope: :victual_id }
end
