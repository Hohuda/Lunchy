class User < ApplicationRecord

  after_create :lunches_admin!
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  

  has_many :orders
  has_one_attached :avatar
  

  private

    def lunches_admin!
      User.first.update_attribute(:admin, true)
    end

end
