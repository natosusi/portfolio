class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  #include SessionsHelper
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :get_notifications

  def get_notifications
    @notifications = current_user&.notifications&.not_returned
  end
end
