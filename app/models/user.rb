class User < ApplicationRecord

  after_create :lunches_admin!
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  

  has_many :orders
  has_one_attached :avatar

  # Adds menu to menus if user is admin
  def add_menu(name = 'menu_name')
    if admin 
      Menu.create name: name
    else
      return false
    end
  end

  # Adds order with victuals, or not
  def add_order(item_collection = nil)
    order = orders.create                                #<<<<----------------REWORK?
    if item_collection
      order.add_items item_collection
    end
  end
  
  # # Adds complex order of 3 main categories victuals
  # def add_complex_order(first_course:, main_course:, drink:)
  #   if first_course.is_a?(Victual) && first_course.is_first_course?
  #     add_item(first_course)
  #   else
  #     return false
  #   end

  #   if main_course.is_a?(Victual) && main_course.is_main_course?
  #     add_item(main_course)
  #   else
  #     return false
  #   end

  #   if drink.is_a?(Victual) && drink.is_drink?
  #     add_item(drink)
  #   else
  #     return false
  #   end
  # end

  private

    def lunches_admin!
      User.first.update_attribute(:admin, true)
    end

end
