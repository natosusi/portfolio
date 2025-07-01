class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to book_path(id: @review.book_id), notice: 'レビューを投稿しました。'
    else
      render book_path(id: @review.book_id)
    end

  end

  private

  def review_params
    params.require(:review).permit(:book_id, :title, :comment)
  end
end
