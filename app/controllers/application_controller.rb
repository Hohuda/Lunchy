class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  before_action :authenticate_user!

  layout :layout_by_resource

  private
  
  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  def not_authorized
    redirect_back(fallback_location: root_path)
  end

  def is_user_admin_universal_policy
    redirect_back(fallback_location: root_path) unless current_user&.admin?
  end
end
