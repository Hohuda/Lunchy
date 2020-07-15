class OrdersController < ApplicationController
  before_action :load_order, only: [:edit, :update, :show, :destroy, :submit]

  def index
    authorize Order
    @orders = Order.paginate(page: params[:page])
  end

  
  def show
    @order = Order.find(params[:id])
    authorize @order
  end
  
  def new
    @order = Order.new
  end
  
  def edit
    authorize @order
  end
  
  def create
    @order = Order.new(order_params)
    authorize @order
    if @order.save
      flash[:success] = "Order was successfuly created!"
      redirect_to @order
    else
      render 'new'
    end
  end
  
  def update
    authorize @order
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
    authorize @order
    @order.destroy
    
    if current_user.admin?
      redirect_to orders_path
    elsif current_user
      @user = User.find(@order.user_id)
      redirect_to orders_for_user_path(@user)
    end
  end
  
  def submit
    authorize @order
    @order.submit
    render 'show'
  end
  
  def today
    authorize Order
    @orders = Order.today_orders
    @date = Date.today.strftime("%B %d, %Y")
    
    respond_to do |format|
      format.html { render 'for_day' }

      format.json do
        render json: @orders.to_json(include: [:victuals])
      end
    end
  end
  
  def for_day
    authorize Order

    if params[:search].present?
      date = params[:search][:order_date]
      @date = Date.parse(date).strftime("%B %d, %Y")
      @orders = Order.search_by_date(date).paginate(page: params[:page])
    end
  end

  private
  
  def order_params
    params.require(:order).permit(:id, :user_id, :menu_id, victual_ids: [])
  end
  
  def load_order
    @order = Order.find(params[:id])
  end
end
