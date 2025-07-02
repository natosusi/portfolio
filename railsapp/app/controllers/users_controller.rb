class UsersController < ApplicationController

  def show
    @lendings = current_user.lendings.order(id: "DESC").page(params[:page]).per(5)

    @likes = current_user.likes.page(params[:page]).per(6)

    @liked_books = @likes.map do |like|
      Book.find(like.book_id)
    end
  end

end
