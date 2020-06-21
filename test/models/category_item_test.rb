require 'test_helper'

class CategoryItemTest < ActiveSupport::TestCase

  def setup
    @category = categories(:first_courses)
    @victual = Victual.create(name: 'vic', price: 1.11)
    @secvic = Victual.create(name: 'vic2', price: 2.22)
  end

  test "validation" do 
    assert_no_difference "CategoryItem.count" do
      CategoryItem.create 
      CategoryItem.create category_id: @category.id
      CategoryItem.create victual_id: @victual.id
    end

    assert_difference "CategoryItem.count" do
      # This one to assert that category item with correct attributes is created
      CategoryItem.create category_id: @category.id, victual_id: @victual.id
      # This one to assert that no category item with duplicate attibutes is created
      CategoryItem.create category_id: @category.id, victual_id: @victual.id
    end
  end

end
