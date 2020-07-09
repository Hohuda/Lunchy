class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  protected 
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :company])
      devise_parameter_sanitizer.permit(:account_update) do |edit_params|
        edit_params.permit(:name, :company, :avatar, :current_password)
      end
    end

  private 
  
  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
  
  def is_user_admin?
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
