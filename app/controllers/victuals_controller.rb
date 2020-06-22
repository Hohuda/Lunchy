class VictualsController < ApplicationController

  def index
    @victuals = Victual.paginate(params[:page])
  end
 
  def show
    @victual = Victual.find(params[:id])
  end
 
  def new
    @victual = Victual.new
  end
 
  def edit
    @victual = Victual.find(params[:id])
  end
 
  def create
    @victual = Victual.new(article_params)
 
    if @victual.save
      flash[:success] = "Victual successfuly added!"
      redirect_to @victual
    else
      flash[:danger] = "Problem has appeared."
      render 'new'
    end
  end
 
  def update
    @victual = Victual.find(params[:id])
 
    if @victual.update(article_params)
      flash[:success] = "Victual successfuly updated!"
      redirect_to @victual
    else
      flash[:danger] = "Problem has appeared."
      render 'edit'
    end
  end
 
  def destroy
    @victual = Victual.find(params[:id])
    @victual.destroy
 
    redirect_to victuals_path
  end
 
  private
    def article_params
      params.require(:victual).permit(:title, :text)
    end

end
