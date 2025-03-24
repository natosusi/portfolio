class LoansController < ApplicationController
  def index
    puts "indexが呼び出された"
    #booksテーブルとloansテーブルを結合して、書籍タイトルと最新の貸し出し状況と返却日を変数@booksに代入する
    #@books = Book.left_outer_joins(:loans).select('books.*, loans.returned_date, loans.schedule_date').distinct
    #本のレコードとその本に関する貸出情報をすべて取得
    @books = Book.includes(:loans).all
  end

  def new
    puts "newが呼び出された"
    #params[:id]を受け取り、find_byメソッドで該当する書籍を検索する
    @book = Book.find_by(id: params[:id])
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
  end

  def update
  end

  def destroy
  end 

   private
    def loan_params
      params.require(:loan).permit(:user_id, :book_id, :borrowed_date, :schedule_date, :returned_date)
    end
end
