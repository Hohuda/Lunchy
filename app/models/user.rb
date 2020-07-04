class User < ApplicationRecord
  has_many :orders

  validates :name, presence: true, uniqueness: true

  after_create :lunches_admin!
  
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
      User.first.update(admin: true)
    end
end
