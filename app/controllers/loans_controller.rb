class LoansController < ApplicationController
  before_action :set_book, only: [:new, :edit, :update]
  before_action :authorize_user!, only: [:edit, :update]
  helper_method :book_available?, :schedule_date_for_loan, :latest_loan_user

  def index
    puts "indexが呼び出された"
    #booksテーブルとloansテーブルを結合して、書籍タイトルと最新の貸し出し状況と返却日を変数@booksに代入する
    #@books = Book.left_outer_joins(:loans).select('books.*, loans.returned_date, loans.schedule_date').distinct
    #本のレコードとその本に関する貸出情報をすべて取得
    @books = Book.includes(:loans).all
  end

  #引数bookを渡し、Bookモデルのlatest_loanメソッドを呼び出しその結果を返す
   #def book_latest_loan(book)
    #book.latest_loan
  #end

  #貸出中のユーザーとログインユーザーの一致判定
  def latest_loan_user(book)
    return true if book.latest_loan.user_id == current_user.id
  end

  #貸出状態の判定
  def book_available?(book)
    #その本の貸出情報が存在しない場合trueを返す
    return true unless book.loans.exists?
    #最新の返却日がnilではない場合、trueを返しnilの場合falseを返す
    !book.latest_loan.returned_date.nil?
  end

  #引数bookを渡し、その最新の貸出情報から返却予定日を返す。loanがnilの場合はnilを返す。
  def schedule_date_for_loan(book)
    book.latest_loan&.schedule_date
  end


  def new
    puts "newが呼び出された"
    #params[:id]を受け取り、find_byメソッドで該当する書籍を検索する
    #@book = Book.find(params[:id])
    #新たな貸し出し情報に必要な項目（書籍、ログイン中の会員、返却予定日←これは1週間後のみ）貸出日はupdated_atレコードの更新日が基準
    @loan = Loan.new(book: @book, user: current_user, schedule_date: 1.week.from_now.to_date)
  end

  def create 
    #現在のユーザーに紐づいた貸出情報を作成する
    #current_user.loansで現在ログイン中の会員と新しく作成される貸出情報が紐づけられる。（user_idが自動的に設定される）
    @loan = current_user.loans.build(loan_params)
    if @loan.save
    redirect_to loans_path, notice: '貸出が完了しました。'
    else
      @book =  @loan.book
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @latest_loan = @book.latest_loan
  end

  def update
    @latest_loan = @book.latest_loan

    #返却日を現在の日付で登録する
    if @latest_loan.update(returned_date: Time.current)
      redirect_to loans_path, notice: '返却が完了しました。'
    else
      flash.now[:alert] = '返却に失敗しました。'
      render :edit
    end
  end

  def destroy
  end 

   private
   #params[:id]を受け取り、find_byメソッドで該当する書籍を検索する
    def set_book
      @book = Book.find(params[:id])
    end

    #返却操作のアクセス制限条件
    def authorize_user!
      #本の最新の貸出情報を取得する
      latest_loan = @book.latest_loan

      #最新の貸出情報が存在しているかの判定
      unless latest_loan
        redirect_to loans_path, alert: 'この本には貸出情報がありません。' and return
      end

      #最新の貸出情報にある会員idとログイン中の会員idが一致するかの判定
      unless latest_loan.user_id == current_user.id
        redirect_to loans_path, alert: 'この本は他の会員に貸出中です。' and return
      end

      #返却済みかどうかの判定
      if latest_loan.returned_date.present?
        redirect_to loans_path, alert: 'この本はすでに返却され、現在貸出可能です。' and return
      end
      
    end

    def loan_params
      params.require(:loan).permit(:user_id, :book_id, :borrowed_date, :schedule_date, :returned_date)
    end
end
