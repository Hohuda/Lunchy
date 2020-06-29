class MenusController < ApplicationController

  def index
    unless params[:search].nil?
      @date = params[:search][:order_date]
      @menus = Menu.search_by_date(@date).paginate(page: params[:page])
      render 'for_day'
    else
      @menus = Menu.paginate(page: params[:page])
    end
  end
  
  def show
    @menu = Menu.find(params[:id])
  end
  
  def new
    @menu = Menu.new
  end
  
  def edit
    @menu = Menu.find(params[:id])
  end
  
  def create
    @menu = Menu.new(menu_creating_params)
    if @menu.save
      @menu.change_victuals(params[:menu][:victual_ids])
      redirect_to @menu
    else
      render 'new'
    end
  end
  
  def update
    @menu = Menu.find(params[:id])
    @menu.change_victuals(params[:menu][:victual_ids])
    if @menu.update(menu_params)
      redirect_to @menu
    else
      render 'edit'
    end
  end
  
  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    
    redirect_to menus_path
  end
  
  def today_menus
    @menus = Menu.today_menus.paginate(page: params[:page])
  end
  
  private
    def menu_params
      params.require(:menu).permit(:id, :name, victual_ids: [])
    end
    
    def menu_creating_params
        params.require(:menu).permit(:id, :name)
    end

end
