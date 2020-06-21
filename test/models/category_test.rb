require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup 
    @category = Category.create name: 'test_category'
  end

  test "validation" do
    assert_no_difference "Category.count" do
      # Creating category with no name
      Category.create
      # Creating category with already existing name
      Category.create name: @category.name 
    end

    # Creating category with unique name
    assert_difference "Category.count" do
      Category.create name: 'different name'     
    end
  end

  test "should return first_courses scope" do
    first_courses_category = Category.find_by(name: 'first_courses')
    assert_equal first_courses_category, Category.first_courses
  end

  test "should return main_courses scope" do
    main_courses_category = Category.find_by(name: 'main_courses')
    assert_equal main_courses_category, Category.main_courses
  end

  test "should return drinks scope" do
    drinks_category = Category.find_by(name: 'drinks')
    assert_equal drinks_category, Category.drinks
  end
end
