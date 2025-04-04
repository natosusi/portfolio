class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  #include SessionsHelper
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    puts "★ApplicationControllerのafter_sign_in_path_forが呼び出された"
    p current_user
    lendings_path
    
  end

  def after_sign_out_path_for(resource_or_scope)
    puts "★ApplicationControllerのafter_sign_out_path_forが呼び出された"
    new_user_session_path
  end

  def after_sign_up_path_for(resource)
    puts "★ApplicationControllerのafter_sign_up_path_forが呼び出された"
    user_path(current_user.id)
   end

  # The path used after sign up for inactive accounts.
   def after_inactive_sign_up_path_for(resource)
    puts "★ApplicationControllerのafter_inactive_sign_up_path_forが呼び出された"
    user_path(current_user.id)
   end
end
