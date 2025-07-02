class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  #include SessionsHelper
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :get_notifications

  def get_notifications
    @notifications = current_user&.notifications&.not_returned
  end

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to main_app.books_path, alert: '画面を閲覧する権限がありません。'
  end
end
