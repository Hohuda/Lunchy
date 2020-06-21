class OrderItem < ApplicationRecord

  belongs_to :order
  belongs_to :menu_item

  validates :order_id, presence: true
  validates :menu_item_id, presence: true

end
