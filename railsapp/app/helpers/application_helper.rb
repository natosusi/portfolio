module ApplicationHelper
  #貸出中のユーザーとログインユーザーの一致判定
  def latest_lending_user(book)
    return true if book.latest_lending.user_id == current_user.id
  end

  #貸出状態の判定
  def book_available?(book)
    #その本の貸出情報が存在しない場合trueを返す
    return true unless book.lendings.exists?
    #最新の返却日がnilではない場合、trueを返しnilの場合falseを返す
    !book.latest_lending.returned_date.nil?
  end
  
  #引数bookを渡し、その最新の貸出情報から返却予定日を返す。lendingがnilの場合はnilを返す。
  def schedule_date_for_lending(book)
    book.latest_lending&.schedule_date
  end

  def uncheck_notification
    current_user.notifications.unchecked
  end

end
