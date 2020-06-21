require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @user = users(:first_user)
    @order = orders(:first_order)
    @menu = menus(:today_menu)
    @borsh = victuals(:borsh)
    @lasagna = victuals(:lasagna)
    @vic_no_menu = Victual.create name: 'No menu', price: 1.11
    @lasagna_menu_item = @menu.menu_items.find_by(victual_id: @lasagna)
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
    # Tests for adding collections of items of Victual or MenuItem class
    assert_difference "@order.menu_items.count", 6 do
      @order.add_items @menu.victuals.first(3)
      @order.add_items @menu.menu_items.last(3)
    end
    # Tests for removing collections of items of Victual or MenuItem class
    assert_difference "@order.menu_items.count", -6 do
      @order.remove_items @order.victuals.first(3)
      @order.remove_items @order.menu_items.last(3)
    end
    # Tests for adding one Victual and MenuItem
    assert_difference "@order.menu_items.count", 2 do
      @order.add_items @borsh
      @order.add_items @lasagna_menu_item
    end
    # Tests for removing one Victual and MenuItem
    assert_difference "@order.menu_items.count", -2 do
      @order.remove_items @borsh
      @order.remove_items @lasagna_menu_item
    end
  end

  test "should not add/remove items" do
    @lasagna_menu_item = @menu.menu_items.find_by(victual_id: @lasagna)
    @order.add_items @lasagna
    order_item = @order.order_items.find_by(menu_item_id: @lasagna_menu_item.id)
    assert_no_difference "@order.menu_items.count" do
      assert_not @order.add_items(nil)
      assert_not @order.add_items(@vic_no_menu)
      assert_difference "order_item.reload.quantity" do
        @order.add_items @lasagna
      end
      assert_difference "order_item.reload.quantity", -1 do
        assert_not @order.remove_items(nil)
        assert_not @order.remove_items(@vic_no_menu)
        @order.remove_items @lasagna
      end
    end
  end

end
