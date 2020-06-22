class MenusController < ApplicationController

  def index
    @menus = Menu.paginate(page: params[:page])
  end

  def today_menus
    @menus = Menu.today_menus.paginate(page: params[:page])
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
    @menu = Menu.new(article_params)
 
    if @menu.save
      redirect_to @menu
    else
      render 'new'
    end
  end
 
  def update
    @menu = Menu.find(params[:id])
 
    if @menu.update(article_params)
      redirect_to @menu
    else
      render 'edit'
    end
  end
 
  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
 
    redirect_to articles_path
  end
 
  private
    def article_params
      params.require(:menu).permit(:title, :text)
    end

end
