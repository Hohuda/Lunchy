class UsersController < ApplicationController

  def index
    @users = User.paginate(page: params[:page])
  end
 
  def show
    @user = User.find(params[:id])
  end
 
  def new
    @user = User.new
  end
 
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
