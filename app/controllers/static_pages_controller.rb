class StaticPagesController < ApplicationController

  skip_before_action :authenticate_user!, only: :home
  
  def home
  end
  
  def order_feed
    @feed_items = Order.all
  end

end
