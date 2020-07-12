class CategoriesController < ApplicationController
  before_action :load_category, only: [:edit, :show]

  def index
    @categories = Category.all
  end
 
  def show
    @victuals = @category.victuals.paginate(page: params[:page])
    render 'victuals/index'
  end
 
  def new
    @category = Category.new
  end
 
  def create
    @category = Category.new(categories_params)
 
    if @category.save
      redirect_to categories_path
    else
      render 'new'
    end
  end
 
  def delete; end

  def destroy
    Category.remove_by_id(params[:category_delete][:category_ids])
    redirect_to categories_path
  end

  private

  def categories_params
    params.require(:category).permit(:id, :name)
  end

  def load_category
    @category = Category.find(params[:id])
  end
end
