class OrdersController < ApplicationController

  def index
    unless params[:search].nil?
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
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
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
    @order = Order.find(params[:id])
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
    @order = Order.find(params[:id])
    @order.destroy
    
    if current_user.admin?
      redirect_to orders_path
    elsif current_user
      redirect_to user_orders_path(user_id: @order.user_id)
    end
  end
 
  def submit 
    @order = Order.find(params[:id])
    @order.submit
    render 'show'
  end

  def today
    @orders = Order.today_orders
    render json: @orders.to_json(include: [:victuals])

    # respond_to do |format|
    #   # format.html
    #   # format.json { render json: @orders }
    # end
  end

  private
    def order_params
      params.require(:order).permit(:id, :user_id, :menu_id, victual_ids: [])
    end

end
