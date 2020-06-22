class User < ApplicationRecord

  after_create :lunches_admin!
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  

  has_many :orders

  mount_uploader :avatar, AvatarUploader

  # Adds menu to menus if user is admin
  def new_menu(name = 'menu_name')
    if admin? 
      Menu.create name: name
    else
      return false
    end
  end

  # Adds order with victuals, or not
  def new_order(item_collection = nil)
    order = orders.create                                #<<<<----------------REWORK?
    if item_collection
      order.add_items item_collection
    end
  end
  
  def admin?
    if admin
      return true
    else
      return false
    end
  end

  private

    def lunches_admin!
      User.first.update_attribute(:admin, true)
    end

end
