require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @user = users(:first_user)
    @order = orders(:first_order)
    @menu = menus(:today_menu)
    @victual = victuals(:borsh)
  end

  test "validation and callbacks" do 
    # Tests for presence
    assert_no_difference "Order.count" do
      Order.create 
    end
    # Tests for callbacks
    assert_difference "Order.count" do
      order = Order.create user: @user   
      # Test for adding total cost callback
      assert_not_nil order.total_cost
      # Test for adding menu callback
      assert_not_nil order.menu
    end
  end

  test "should add/remove items" do
    assert_empty @order.menu_items
    assert_difference "@order.menu_items.count", 3 do
      @order.add_items @menu.victuals.first(3)
    end
    assert_difference "@order.menu_items.count", -3 do
      @order.remove_items @order.victuals.first(3)
    end
    assert_difference "@order.menu_items.count" do
      @order.add_items @victual
    end
    assert_difference "@order.menu_items.count", -1 do
      @order.remove_items @victual
    end
    assert_difference "@order.menu_items.count", 3 do
      @order.add_items @menu.menu_items.first(3)
    end
    assert_difference "@order.menu_items.count", -3 do
      @order.remove_items @order.menu_items.first(3)
    end
    assert_difference "@order.menu_items.count" do
      @order.add_items @menu.menu_items.find_by(victual_id: @victual)
    end
    assert_difference "@order.menu_items.count", -1 do
      @order.remove_items @order.menu_items.find_by(victual_id: @victual)
    end
  end

end
