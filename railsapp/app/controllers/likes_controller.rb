class LikesController < ApplicationController
  def create
    puts "like createが呼び出された"
    @book = Book.find(params[:book_id])
    p @book.id
    @like = current_user.likes.build(book_id: @book.id)
    p @like
    if @like.save
      redirect_to book_path(@book.id), notice: "お気に入り登録しました！"
    else
      redirect_to book_path(@book.id), alert: "お気に入り登録に失敗しました。"
    end
  end

  def destroy
  end
end
