class NotificationController < ApplicationController
  def index
    @notifications = current_user.notifications.order(id: "DESC").page(params[:page]).per(10)
    #既読処理
    @notifications.unchecked.each do |notification|
      notification.update(checked: true)
    end
  end
end
