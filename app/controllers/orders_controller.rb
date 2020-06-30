class OrdersController < ApplicationController

  def index
    unless params[:search].nil?
      @date = params[:search][:order_date]
      @orders = Order.search_by_date(@date).paginate(page: params[:page])
      @total_cost = @orders.count_total_cost
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
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
  end
  
  def create
    @order = Order.new(order_params)
 
    if @order.save
      flash[:success] = "Order was successfuly created!"
      redirect_to @order
    else
      render 'new'
    end
  end
 
  def update
    @order = Order.find(params[:id])
 
    if @order.update(order_params)
      flash[:success] = "Order was successfuly updated!"
      redirect_to @order
    else
      flash[:danger] = "Problem has appeared."
      render 'edit'
    end
  end
 
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
 
    redirect_to orders_path
  end
 
  private
    def order_params
      params.require(:order).permit(:id, :user_id, :menu_id)
    end

end
