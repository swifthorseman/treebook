class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_filter :configure_permitted_parameters, if: :devise_controller?

  private
  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_up) { |u|
        u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :profile_name)
    }
    devise_parameter_sanitizer.for(:account_update) { |u|
        u.permit(:email, :current_password, :password, :password_confirmation, :first_name, :last_name, :profile_name, :avatar)
    }
  end	

  def render_404
    render file: 'public/404', status: :not_found
  end

end
