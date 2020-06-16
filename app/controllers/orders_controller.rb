class OrdersController < ApplicationController

  def new
    @order = Order.new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      flash[:success] = "Order was successfuly created!"
      redirect_to orders_path
    else  
      flash[:danger] = "Problem has appeared."
      redirect_to orders_path
    end
  end

  private

    def order_params
      params.require(:order).permit(:first_course_id, :main_course_id, :drink_id)
    end

end
