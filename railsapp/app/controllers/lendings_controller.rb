class LendingsController < ApplicationController
  before_action :set_book, only: [:new, :edit]
  before_action :authorize_confirmed, only: [:edit]

  #貸出確認画面
  def new
    #貸出情報が1つ以上存在していて、最新の貸出情報の返却日が登録されていない場合
    if @book.lendings.present? && @book.latest_lending.returned_date.blank?
      #@books = Book.includes(:lendings).page(params[:page]).per(9)
      flash.now[:alert] = 'この本は貸出中です。'
      render "books/index"
      #respond_to do |format|
      #  format.turbo_stream { render turbo_stream: turbo_stream.replace(partial: "layouts/flash") }
      #end
      return
    end
    #新たな貸し出し情報に必要な項目（書籍、ログイン中の会員）貸出日はupdated_atレコードの更新日が基準
    @lending = current_user.lendings.new(book: @book)
  end

  #貸出登録
  def create 
    #現在のユーザーに紐づいた貸出情報を作成する
    #current_user.lendingsで現在ログイン中の会員と新しく作成される貸出情報が紐づけられる。（user_idが自動的に設定される）
    @lending = current_user.lendings.build(lending_params)

    if @lending.save
      redirect_to books_path, notice: '貸出が完了しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  #返却確認画面
  def edit
    #set_bookで取得した本のidに紐づく最新の貸出情報を取得する
    @lending = @book.latest_lending
  end

  #返却登録
  def update
    @lending = Lending.find(params[:id])

    #返却日を現在の日付で登録する
    if @lending.update(returned_date: Date.current)
      redirect_to(request.referer || books_path, notice: '返却が完了しました。')
    else
      redirect_to(request.referer || books_path, alert: '返却に失敗しました。', status: :see_other)
    end
  end

  def destroy
  end 

   private
   #params[:id]を受け取り、findメソッドで該当する書籍を検索する。
    def set_book
      @book = Book.find(params[:id])
    end

    #返却確認画面のアクセス制限条件
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
