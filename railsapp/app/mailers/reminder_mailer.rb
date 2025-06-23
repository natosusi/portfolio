class ReminderMailer < ApplicationMailer
  def reminder(lending)
    @lending = lending
    mail(to: @lending.user.email, subject: "【返却期限のお知らせ】『#{@lending.book.title}』のご返却について")
  end
end
