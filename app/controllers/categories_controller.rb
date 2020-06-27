class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
 
  def show
    @category = Category.find(params[:id])
    @victuals = @category.victuals.paginate(page: params[:page])
    render 'victuals/index'
  end
 
  def new
    @category = Category.new
  end
 
  def edit
    @category = Category.find(params[:id])
  end
 
  def create
    @category = Category.new(categories_params)
 
    if @category.save
      redirect_to categories_path
    else
      render 'new'
    end
  end
 
  def update
    render 'index'
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
 
    redirect_to categories_path
  end

  def delete
    @categories = Category.all
  end

  private
    def categories_params
      params.require(:category).permit(:id, :name)
    end
end
