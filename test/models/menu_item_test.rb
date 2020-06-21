require 'test_helper'

class MenuItemTest < ActiveSupport::TestCase
   
  def setup
    @menu = menus(:today_menu)
    @victual = Victual.create(name: 'vic', price: 1.11)
  end

  test "validation" do 
    assert_no_difference "MenuItem.count" do
      MenuItem.create 
      MenuItem.create menu_id: @menu.id
      MenuItem.create victual_id: @victual.id
    end

    assert_difference "MenuItem.count" do
      # This one to assert that menu item with correct attributes is created
      MenuItem.create menu_id: @menu.id, victual_id: @victual.id
      # This one to assert that no menu item with correct attributes is created
      MenuItem.create menu_id: @menu.id, victual_id: @victual.id
    end
  end

end
