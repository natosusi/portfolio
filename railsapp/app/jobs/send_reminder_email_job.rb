class SendReminderEmailJob < ApplicationJob
  queue_as :default

  def perform
    @lendings = Lending.is_the_day_before_due
    if @lendings.empty?
      puts "現在期限が迫っている貸出はありません"
      return
    end

    @lendings.each do |lending|
      email = lending.user.email
      ReminderMailer.reminder(email).deliver_later
    end
  end
end
