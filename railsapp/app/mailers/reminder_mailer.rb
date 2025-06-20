class ReminderMailer < ApplicationMailer
  def reminder(email)
    @lendings = Lending.is_the_day_before_due
    mail(to: email, subject: '返却期限のお知らせ')
  end
end
