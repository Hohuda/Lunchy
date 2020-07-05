class User < ApplicationRecord
  has_many :orders

  validates :name, presence: true, uniqueness: true

  before_save :lunches_admin!
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  mount_uploader :avatar, AvatarUploader

  def admin?
    admin
  end

  private
    def lunches_admin!
      self.admin = true if self.id == 1
    end
end
