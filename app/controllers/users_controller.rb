class UsersController < ApplicationController

  # before_action :is_user_admin?, except: [:show]

  def index
    @users = User.order(:name).paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.json do
        render json: { data: @users , status: :ok, message: 'success' }
      end
    end
  end
 
  def show
    # if current_user.id == params[:id].to_i
      @user = User.find(params[:id])
    # else redirect_to root_path
    # end

    respond_to do |format|
      format.html
      format.json do
        render json: { data: @user, status: :ok, message: 'success'}
      end
    end
  end
 
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
