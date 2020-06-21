require 'test_helper'

class MenuTest < ActiveSupport::TestCase
  def setup
    @menu = Menu.create name: 'test_menu'
    @today_menu = menus :today_menu
  end

  test "should add and delete victuals to menu" do
    # Tests for add/remove victual
    assert_difference '@menu.victuals.count' do
      @menu.add_victual victuals(:borsh)
    end
    assert_not @menu.add_victual nil

    assert_difference '@menu.victuals.count', -1 do
      assert @menu.remove_victual victuals(:borsh)
    end
    assert_not @menu.remove_victual nil
    assert_not @menu.remove_victual victuals(:borsh)

    # Tests for add/remove victuals
    assert_difference '@menu.victuals.count', victuals.count do
      @menu.add_victuals victuals
    end
    assert_difference '@menu.victuals.count', -victuals.count do
      @menu.remove_victuals victuals
    end
    

  end

  test "should return today_menus" do
    collection = Menu.today_menus
    assert_includes collection, @menu
    assert_includes collection, @today_menu
  end

  test "should return first/main courses and drinks" do 
    assert_empty @menu.victuals
    vic = Victual.create name: 'vic', price: 2.5
    @menu.add_victual vic

    vic.to_first_courses
    assert_includes @menu.first_courses, vic

    vic.to_main_courses
    assert_includes @menu.main_courses, vic

    vic.to_drinks
    assert_includes @menu.drinks, vic
  end

end
