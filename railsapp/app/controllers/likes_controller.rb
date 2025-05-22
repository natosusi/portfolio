class LikesController < ApplicationController
  before_action :set_book, only: [:create, :destroy]

  def create
    @like = current_user.likes.build(book: @book)

    if @like.save
      redirect_to book_path(@book), notice: "お気に入り登録しました！"
    else
      redirect_to book_path(@book), alert: "お気に入り登録に失敗しました。"
    end
  end

  def destroy
    @like = @book.likes.find(params[:id])

    if @like && @like.user_id == current_user.id
      @like.destroy
      redirect_to(request.referer || book_path(@book), notice: "お気に入り解除しました。")
    else
      redirect_to(request.referer || book_path(@book), alert: "お気に入り解除に失敗しました。")
    end

    respond_to do |format|
      format.html { render user_path(current_user) }
      format.turbo_stream
    end
  end

  private
  def set_book
    @book = Book.find(params[:book_id])
  end
end
