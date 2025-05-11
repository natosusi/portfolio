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
    puts "like destroyが呼び出された"
    @book = Book.find(params[:book_id]) 
    @like = Like.find(params[:id])
    puts "user_idは#{@like.user_id}"
    if @like && @like.user_id == current_user.id
      @like.destroy
      redirect_to(request.referer || book_path(@book.id), notice: "お気に入り解除しました。")
    else
      redirect_to(request.referer || book_path(@book.id), alert: "お気に入り解除に失敗しました。")
    end
  end
end
