class UsersController < ApplicationController

  # before_action :is_user_admin?, except: [:show]

  def index
    authorize current_user

    @users = User.order(:name).paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.json do
        render json: { data: @users , status: :ok, message: 'success' }
      end
    end
  end
 
  def show
    @user = User.find(params[:id])
    authorize @user
    respond_to do |format|
      format.html
      format.json do
        render json: { data: @user, status: :ok, message: 'success'}
      end
    end
  end

  def orders
    @user = User.find(params[:id])
    authorize @user
    @orders = Order.where(user_id: params[:id]).paginate(page: params[:page])
    respond_to do |format|
      format.html { render 'orders/index'}
      format.json do
        render json: { data: @user.to_json(include: [@orders]) }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
