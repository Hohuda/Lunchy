require 'test_helper'

class VictualTest < ActiveSupport::TestCase
  def setup
    @victual = Victual.create name: 'test_victual', price: 9.00
  end

  test "validation" do
    assert_no_difference "Victual.count" do
      # Tests for presence
      Victual.create
      Victual.create name: 'test'
      Victual.create price: 9.99
      # Test for name uniqueness
      Victual.create name: @victual.name 
    end

    # Creating victual with price and unique name
    assert_difference "Victual.count" do
      # This one to assert that victual with correct attributes is created
      Victual.create name: 'test', price: 9.99
      # This one to assert that no victual with duplicated attributes is created
      Victual.create name: 'test', price: 9.99
    end
  end

  test "should add and delete category" do 
    # Assert no categories on victual
    assert_empty @victual.categories

    # Tests for adding category
    assert_difference '@victual.categories.count', 2 do
      @victual.to_first_courses
      @victual.to_main_courses
    end
    assert_not @victual.add_category(nil), msg: 'Should remove only category clas'
    assert_not @victual.remove_category(nil), msg: 'Should remove only category class' 

    # Tests for removing category
    assert_difference '@victual.categories.count', -1 do
      @victual.remove_category Category.first_courses
    end

    assert_not_includes @victual.categories, Category.first_courses
    assert_not @victual.remove_category(Category.first_courses), msg: "Can't remove non existing categories"
  end

  test "should return correct scopes" do
    # Tests for first_courses scope
    assert_not Victual.first_courses.include?(@victual)
    @victual.to_first_courses
    assert Victual.first_courses.include?(@victual)

    # Tests for main_courses scope
    assert_not Victual.main_courses.include?(@victual)
    @victual.to_main_courses
    assert Victual.main_courses.include?(@victual)

    # Tests for drinks scope
    assert_not Victual.drinks.include?(@victual)
    @victual.to_drinks
    assert Victual.drinks.include?(@victual)
  end

  test "should make correct checks" do
    # Tests is_first_course check
    assert_not @victual.is_first_course?
    @victual.to_first_courses
    assert @victual.is_first_course?

    # Tests is_main_course check
    assert_not @victual.is_main_course?
    @victual.to_main_courses
    assert @victual.is_main_course?
    
    # Tests is_drink check
    assert_not @victual.is_drink?
    @victual.to_drinks
    assert @victual.is_drink?
  end


end
