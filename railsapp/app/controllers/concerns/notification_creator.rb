module NotificationCreator

  def create_notification
    @due_lendings = current_user.lendings.due_date
    return if @due_lendings.blank?

    @due_lendings.each do |lending|
      notification = current_user.notifications.build(lending: lending, action_type: 1)
      next if !notification.save
    end
  end
end