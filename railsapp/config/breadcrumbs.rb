crumb :root do
  link "HOME", books_path
end

crumb :book_show do |book|
  link "書籍詳細-#{book.title}", book_path(book)
  parent :root
end

crumb :books_search do
  link "書籍検索・登録", search_books_path
  parent :root
end

crumb :user_show do
  link "会員詳細-#{current_user.name}", user_path(current_user)
  parent :root
end

crumb :user_edit do |user|
  link "会員情報変更", edit_user_registration_path
  parent :user_show
end