module NotificationHelper
  def action_due_date?(notification)
    return true if notification.action_type == 1
  end

  def lending_not_returned(notification)
    return true if notification.lending.returned_date == nil
  end
end
