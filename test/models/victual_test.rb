require 'test_helper'

class VictualTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @victual = Victual.new name: 'Victual', price: 1.99, category: categories(:first_courses)
  end

end
