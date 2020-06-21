require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  
  def setup
    @order = orders(:first_order)
    @menu_item = menu_items(:lasagna_menu_item)
  end

  test "validation" do 
    assert_no_difference "OrderItem.count" do
      OrderItem.create 
      OrderItem.create order_id: @order.id
      OrderItem.create menu_item_id: @menu_item.id
    end

    assert_difference "OrderItem.count" do
      # This one to assert order item with correct attributes is created
      OrderItem.create order_id: @order.id, menu_item_id: @menu_item.id
      # This one to assert no order item with duplicated attributes is created
      OrderItem.create order_id: @order.id, menu_item_id: @menu_item.id
    end
  end

end
