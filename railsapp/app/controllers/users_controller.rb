class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
  end

  def show
    #ログイン中の会員に紐づいた貸出履歴を取得
    @lendings = current_user.lendings.order(id: "DESC").page(params[:page]).per(5)

    #ログイン中の会員がお気に入り登録済の書籍をlikesのレコードから取得する。
    @likes = current_user.likes.page(params[:page]).per(6)

    #@liked_booksにlikesのレコードから取得した書籍情報の配列を格納する。これによりビューで書籍情報が表示できる。
    @liked_books = @likes.map do |like|
      Book.find(like.book_id)
    end
  end

end
