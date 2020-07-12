class MenusController < ApplicationController

  # before_action :is_user_admin?, except: [:today, :index, :show]
  before_action :load_menu, only: [:edit, :show, :update, :destroy]
  before_action :is_user_admin_universal_policy, except: [:today, :show]
  
  def index
    if params[:search].present?
      @date = params[:search][:order_date]
      @menus = Menu.search_by_date(@date).paginate(page: params[:page])
      render 'for_day'
    else
      @menus = Menu.paginate(page: params[:page])
    end
  end
  
  def show; end
  
  def new
    @menu = Menu.new
  end
  
  def edit; end
  
  def create
    @menu = Menu.new(menu_creating_params)
    if @menu.save
      @menu.set_victuals(params[:menu][:victual_ids])
      redirect_to @menu
    else
      render 'new'
    end
  end
  
  def update
    @menu.set_victuals(params[:menu][:victual_ids])
    if @menu.update(menu_params)
      redirect_to @menu
    else
      render 'edit'
    end
  end
  
  def destroy
    @menu.destroy
    
    redirect_to menus_path
  end
  
  # today_menus_path
  def today
    @menus = Menu.today_menus.paginate(page: params[:page])
  end
  
  private

  def menu_params
    params.require(:menu).permit(:id, :name, victual_ids: [])
  end
  
  def menu_creating_params
    params.require(:menu).permit(:id, :name)
  end

  def load_menu
    @menu = Menu.find(params[:id])
  end
end
