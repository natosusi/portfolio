class LendingsController < ApplicationController
  before_action :set_book, only: [:new, :edit]
  before_action :authorize_return, only: [:edit]

  #書籍一覧
  def index
    #本のレコードとその本に関する貸出情報をすべて取得
    @books = Book.includes(:lendings).page(params[:page]).per(9)
  end

  #貸出確認画面
  def new
    #貸出情報が1つ以上存在していて、返却されていない場合（最新の貸出レコードの返却日が記録されていない場合）
    if @book.lendings.any? && @book.latest_lending.returned_date.nil?
      redirect_to lendings_path, alert: 'この本は貸出中です。', status: :see_other and return
    end
    #新たな貸し出し情報に必要な項目（書籍、ログイン中の会員、返却予定日←これは1週間後のみ）貸出日はupdated_atレコードの更新日が基準
    @lending = Lending.new(book: @book, user: current_user)
  end

  #貸出登録
  def create 
    #現在のユーザーに紐づいた貸出情報を作成する
    #current_user.lendingsで現在ログイン中の会員と新しく作成される貸出情報が紐づけられる。（user_idが自動的に設定される）
    @lending = current_user.lendings.build(lending_params)

    if @lending.save
      redirect_to lendings_path, notice: '貸出が完了しました。'
    else
      flash.now[:alert] = '返却予定日を指定してください。'
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
      redirect_to lendings_path, notice: '返却が完了しました。'
    else
      flash.now[:alert] = '返却に失敗しました。'
      redirect_to :edit
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
    def authorize_return

      #貸出情報が存在しているかの判定。存在していない場合、アラートを出し書籍一覧に戻る。
      if @book.lendings.blank?
        redirect_to lendings_path, alert: 'この本には貸出情報がありません。', status: :see_other and return
      end

      #最新の貸出情報の返却日が登録されているかの判定。登録されている場合、アラートを出し書籍一覧に戻る。
      if @book.latest_lending.returned_date.present?
        redirect_to lendings_path, alert: 'この本はすでに返却され、現在貸出可能です。', status: :see_other and return
      end

      #貸出情報の会員idと現在ログイン中の会員idが一致しているかの判定。一致していない場合、アラートを出し書籍一覧に戻る。
      if @book.latest_lending.user_id != current_user.id
        redirect_to lendings_path, alert: 'この本は他の会員に貸出中です。', status: :see_other and return
      end

    end
    
    def lending_params
      params.require(:lending).permit(:user_id, :book_id, :borrowed_date, :schedule_date, :returned_date)
    end
end
