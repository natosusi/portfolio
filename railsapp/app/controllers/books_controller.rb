class BooksController < ApplicationController
  before_action :check_ability, only: [:search, :create]

  def index
    @books = Book.includes(:lendings).page(params[:page]).per(9)
  end
  
  def search
    @isbn = params[:isbn].to_s.strip

    #判定1:変数isbnの値が存在しているが、データが空の場合、処理が停止する。
    if @isbn.blank?
      return
      #判定2:数字以外が含まれている場合、処理が停止する。アラートを表示して変数isbnを空にする。
    elsif !@isbn.match?(/\A\d+\z/)
      @isbn = ""
      flash.now[:alert] = '数字以外が含まれています。13桁のISBNコードを正しく入力してください。'
      render :search, status: :unprocessable_entity and return
      #判定3:値の文字数が13文字ではない場合、処理が停止する。アラートを表示して変数isbnを空にする。
    elsif @isbn.size != 13
      @isbn = ""
      flash.now[:alert] = '13桁のISBNコードを正しく入力してください。'
      render :search, status: :unprocessable_entity and return
    end

    api_key = ENV.fetch('GOOGLE_BOOKS_API_KEY') {""}

    if api_key.blank?
      flash.now[:alert] = 'APIキーが設定されていません。'
      render :search, status: :unprocessable_entity and return
    end

    #ベースURLの設定
    conn = Faraday.new(url: "https://www.googleapis.com") do |f|
      f.response :json, parser_options: { symbolize_names: true }
    end
    #APIリクエストの送信
    res = conn.get("/books/v1/volumes", {q: "isbn:#{@isbn}", country: "JP", key: api_key})

    if !res.success? || res.body[:items].blank?
      flash.now[:alert] = '書籍情報を取得できませんでした'
      @book_info = nil
      render :search, status: :unprocessable_entity and return
    end

    volume = res.body[:items].first[:volumeInfo]

    @book_info = { 
      title: volume[:title],
      authors: volume[:authors]&.join(','),
      description: volume[:description],
      image: volume.dig(:imageLinks, :thumbnail)
    }
    flash.now.notice = '書籍情報を取得しました。'

    respond_to do |format|
      format.html { render search_books_path }
      format.turbo_stream
    end

  end

  def create 
    @book = Book.new(book_params)
 
    if @book.save
      redirect_to search_books_path, notice: '書籍情報を保存しました。'
    else
      flash.now[:alert] = '書籍情報を保存できませんでした'
      render :search, status: :unprocessable_entity and return
    end
    respond_to do |format|
      format.html { render search_books_path }
      format.turbo_stream
    end

  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews.page(params[:page]).per(5)

    @review = Review.new

    if Like.liked_by?(@book, current_user)
      @like = Like.find_by(user_id: current_user.id, book_id: @book.id)
    else
     return
    end

    @likes_count = Like.currently_likes(@book.id).count
  end

  private
  def book_params
    params.require(:book).permit(:title, :author, :description, :image_link)
  end

  def check_ability
    authorize! :access, :books_search
  end
end
