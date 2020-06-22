class OrdersController < ApplicationController

  def index
    @orders = Order.paginate(page: params[:page])
  end

  def orders_of_user
    users_orders = Order.where(user_id: params[:user_id])
    @user = User.find(params[:user_id])
    @orders = users_orders.paginate(page: params[:page])
  end

  def show
    @order = Order.find_by(params[:id])
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
  end
  
  def create
    @order = Order.new(article_params)
 
    if @order.save
      flash[:success] = "Order was successfuly created!"
      redirect_to @order
    else
      render 'new'
    end
  end
 
  def update
    @order = Order.find(params[:id])
 
    if @order.update(article_params)
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
    def article_params
      params.require(:order).permit(:menu_id, :user_id)
    end

end
