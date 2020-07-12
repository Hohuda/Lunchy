class VictualsController < ApplicationController
  # before_action :is_user_admin?
  before_action :load_victual, only: [:edit, :update, :show, :destroy]
  before_action :is_user_admin_universal_policy, except: [:index, :show]

  def index
    victuals, @category = Victual.return_victuals_for_index(params)
    @victuals = victuals.paginate(page: params[:page])
  end
 
  def show; end
 
  def new
    @victual = Victual.new
  end
 
  def edit; end
 
  def create
    @victual = Victual.new(victual_creating_params)
    @victual.avatar = params[:victual][:avatar]
    if @victual.save
      @victual.set_categories(params[:victual][:category_ids])
      redirect_to @victual
    else
      render 'new'
    end
  end
 
  def update
    @victual.set_categories(params[:victual][:category_ids])
    @victual.avatar = params[:victual][:avatar]
    if @victual.update(victual_params)
      redirect_to @victual
    else
      render 'edit'
    end
  end
 
  def destroy
    @victual.destroy
 
    redirect_to victuals_path
  end
 
  private

  def victual_params
    params.require(:victual).permit(:id, :name, :price, category_ids: [], avatar: [])
  end

  def victual_creating_params
    params.require(:victual).permit(:id, :name, :price)
  end

  def load_victual
    @victual = Victual.find(params[:id])
  end
end
