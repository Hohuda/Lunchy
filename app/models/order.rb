require_relative '../validators/order_validator'

class Order < ApplicationRecord

  belongs_to :user
  belongs_to :menu
  has_many :order_items
  has_many :menu_items, through: :order_items
  has_many :victuals, through: :menu_items

  validates_with OrderValidator


end
