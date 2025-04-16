class LendingsController < ApplicationController
  before_action :set_book, only: [:new, :edit]
  before_action :authorize_edit, only: [:edit]
  helper_method :book_available?, :schedule_date_for_lending, :latest_lending_user

  #書籍一覧
  def index
    puts 'indexが呼び出された'
    #本のレコードとその本に関する貸出情報をすべて取得
    @books = Book.includes(:lendings).all
  end

  #貸出中のユーザーとログインユーザーの一致判定
  def latest_lending_user(book)
    return true if book.latest_lending.user_id == current_user.id
  end

  #貸出状態の判定
  def book_available?(book)
    #その本の貸出情報が存在しない場合trueを返す
    return true unless book.lendings.exists?
    #最新の返却日がnilではない場合、trueを返しnilの場合falseを返す
    !book.latest_lending.returned_date.nil?
  end

  #引数bookを渡し、その最新の貸出情報から返却予定日を返す。lendingがnilの場合はnilを返す。
  def schedule_date_for_lending(book)
    book.latest_lending&.schedule_date
  end

  #貸出確認画面
  def new
    puts 'newが呼び出された'
    #新たな貸し出し情報に必要な項目（書籍、ログイン中の会員、返却予定日←これは1週間後のみ）貸出日はupdated_atレコードの更新日が基準
    @lending = Lending.new(book: @book, user: current_user)
  end

  #貸出登録
  def create 
    puts 'createが呼び出された'
    #現在のユーザーに紐づいた貸出情報を作成する
    #current_user.lendingsで現在ログイン中の会員と新しく作成される貸出情報が紐づけられる。（user_idが自動的に設定される）
    @lending = current_user.lendings.build(lending_params)
    if @lending.save
    redirect_to lendings_path, notice: '貸出が完了しました。'
    else
      @book =  @lending.book
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  #返却確認画面
  def edit
    puts 'editが呼び出された'
    p @book
    #set_bookで取得した本のidに紐づく貸出情報を取得する
    @lending = @book.latest_lending
    p @lending
  end

  #返却登録
  def update
    puts 'updateが呼び出された'
    @lending = Lending.find(params[:id])
    p @lending

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
      puts 'set_bookが呼び出された'
      @book = Book.find(params[:id])
      p @book
    end

    #返却確認画面のアクセス制限条件
    def authorize_edit
      puts 'authorize_edit!が呼び出された'
      p @book.latest_lending
      p @book.latest_lending.present?
      p @book.latest_lending.user_id
      p @book.latest_lending.returned_date.nil?

      #最新の貸出情報が存在しているかの判定。存在していない場合、アラートを出し書籍一覧に戻る。
      unless @book.latest_lending.present?
        puts "判定1"
        redirect_to lendings_path, alert: 'この本には貸出情報がありません。', status: :see_other and return
      end

      #貸出情報の会員idと現在ログイン中の会員idが一致しているかの判定。一致していない場合、アラートを出し書籍一覧に戻る。
      unless @book.latest_lending.user_id == current_user.id
        puts "判定2"
        redirect_to lendings_path, alert: 'この本は他の会員に貸出中です。', status: :see_other and return
      end

      #返却日が登録されているかの判定。登録されている場合、アラートを出し書籍一覧に戻る。
      unless @book.latest_lending.returned_date.nil?
        puts "判定3"
        redirect_to '/lendings', alert: 'この本はすでに返却され、現在貸出可能です。', status: :see_other and return
      end
    end
=begin
      #最新の貸出情報が存在しているかの判定
      unless latest_lending
        redirect_to lending_path, alert: 'この本には貸出情報がありません。', status: :unprocessable_entity and return
      end

      #最新の貸出情報にある会員idとログイン中の会員idが一致するかの判定
      unless latest_lending.user_id == current_user.id
        redirect_to lending_path, alert: 'この本は他の会員に貸出中です。', status: :unprocessable_entity and return
      end

      #返却済みかどうかの判定
      if latest_lending.returned_date.present?
        redirect_to lending_path, alert: 'この本はすでに返却され、現在貸出可能です。', status: :unprocessable_entity and return
      end
=end      
    def lending_params
      params.require(:lending).permit(:user_id, :book_id, :borrowed_date, :schedule_date, :returned_date)
    end
end
