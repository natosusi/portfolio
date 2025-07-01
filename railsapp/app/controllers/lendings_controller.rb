class LendingsController < ApplicationController
  before_action :set_book, only: [:new, :edit]
  before_action :authorize_confirmed, only: [:edit]

  def new
    #貸出情報が1つ以上存在していて、最新の貸出情報の返却日が登録されていない場合
    if @book.lendings.present? && @book.latest_lending.returned_date.blank?
      redirect_to books_path, alert: 'この本は貸出中です。', status: :see_other and return
    end
    @lending = current_user.lendings.new(book: @book)
  end

  def create 
    @lending = current_user.lendings.build(lending_params)

    if @lending.save
      redirect_to books_path, notice: '貸出が完了しました。'
    else
      redirect_to books_path, status: :see_other
    end
  end

  def edit
    @lending = @book.latest_lending
  end

  def update
    @lending = Lending.find(params[:id])

    if @lending.update(returned_date: Date.current)
      redirect_to(request.referer || books_path, notice: '返却が完了しました。')
    else
      flash[:alert] = '返却に失敗しました。'
      redirect_to books_path, status: :see_other
    end
  end

   private
    def set_book
      @book = Book.find(params[:id])
    end

    def authorize_confirmed

      #貸出情報が1件もない、または既に最新の貸出情報の返却日が登録されている場合、アラートを出し書籍一覧に戻る。
      if @book.lendings.blank? || @book.latest_lending.returned_date.present?
        redirect_to books_path, alert: 'この本は貸出中でないため、返却登録できません。', status: :see_other and return
      end

      #最新の貸出情報の会員idと現在ログイン中の会員idが一致していない場合、アラートを出し書籍一覧に戻る。
      if @book.latest_lending.user != current_user
        redirect_to books_path, alert: 'この本は他の会員に貸出中のため、返却登録できません。', status: :see_other and return
      end

    end
    
    def lending_params
      params.require(:lending).permit(:user_id, :book_id, :borrowed_date, :schedule_date, :returned_date)
    end
end
