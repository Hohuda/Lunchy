class MenusController < ApplicationController

  def new
    @menu = Menu.new
  end

  def show
    @menu = Menu.find(params[:id])
  end

  def create
    @menu = current_user.menus.build(menu_params)
    if @menu.save

    end
  end

  def add_first_course
    first_course = FirstCourse.new(name: )
  end


  private 

    def menu_params
      params.require(:menu).permit(:first_course_id, :main_course_id, :drink_id)
    end

end
