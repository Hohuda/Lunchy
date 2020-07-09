class OrdersController < ApplicationController
  before_action :load_order, only: [:edit, :update, :show, :destroy, :submit]

  def index
    if params[:search].present?
      @date = params[:search][:order_date]
      @orders = Order.search_by_date(@date).paginate(page: params[:page])
      @total_cost = @orders.calculate_total_income
      render 'for_day'
    else
      @orders = Order.paginate(page: params[:page])
    end
  end

  def for_user
    users_orders = Order.where(user_id: params[:user_id])
    @user = User.find(params[:user_id])
    @orders = users_orders.paginate(page: params[:page])
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
  end
  
  def create
    @user = User.find(params[:order][:user_id])
    @order = @user.orders.create(menu: Menu.find(params[:order][:menu_id]))
    if @order.save
      flash[:success] = "Order was successfuly created!"
      redirect_to @order
    else
      render 'new'
    end
  end
 
  def update
    @order.set_victuals(params[:order][:victual_ids])
    if @order.save
      flash[:success] = "Order was successfuly updated!"
      redirect_to @order
    else
      flash[:danger] = "Problem has appeared."
      render 'edit'
    end
  end
 
  def destroy
    @order.destroy
    
    if current_user.admin?
      redirect_to orders_path
    elsif current_user
      redirect_to user_orders_path(user_id: @order.user_id)
    end
  end
 
  def submit 
    @order.submit
    render 'show'
  end

  def today
    @orders = Order.today_orders
    render json: @orders.to_json(include: [:victuals])
  end

  private

  def order_params
    params.require(:order).permit(:id, :user_id, :menu_id, victual_ids: [])
  end

  def load_order
    @order = Order.find(params[:id])
  end
end
