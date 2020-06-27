class SearchesController < ApplicationController

  def update
    @orders = Order.search_by_date(params[:search_date])
    render 'orders/index'
  end

  private 

    def search_params
      params.require(:search).permit(:search_date)
    end

end
