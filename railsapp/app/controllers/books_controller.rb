class BooksController < ApplicationController
  before_action :check_ability, only: [:search, :create]

  #書籍一覧
  def index
    #本のレコードとその本に関する貸出情報をすべて取得
    @books = Book.includes(:lendings).page(params[:page]).per(9)
  end
  
  def search
    @isbn = params[:isbn].to_s.strip

    #isbnコードの値が正しいか判定する
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

    #APIキーを環境変数から取得する
    api_key = ENV.fetch('GOOGLE_BOOKS_API_KEY') {""}

    #APIキーが設定されていない場合
    if api_key.blank?
      flash.now[:alert] = 'APIキーが設定されていません。'
      render :search, status: :unprocessable_entity and return
    end

    #ベースURLの設定
    conn = Faraday.new(url: "https://www.googleapis.com") do |f|
      #リクエストボディをJSON文字列にエンコード。
      #parser_optionsで文字列をオブジェクトに変換、シンボル化する。
      f.response :json, parser_options: { symbolize_names: true }
    end
    #APIリクエストの送信
    res = conn.get("/books/v1/volumes", {q: "isbn:#{@isbn}", country: "JP", key: api_key})

    #APIリクエストが失敗、またはレスポンスボディにitemsがあり、その中が空の場合
    if !res.success? || res.body[:items].blank?
      flash.now[:alert] = '書籍情報を取得できませんでした'
      @book_info = nil
      render :search, status: :unprocessable_entity and return
    end

    #itemsの先頭のvolumeInfo(書籍情報)をvolumeに格納
    volume = res.body[:items].first[:volumeInfo]

    @book_info = { 
      title: volume[:title],
      authors: volume[:authors]&.join(','),
      description: volume[:description],
      image: volume.dig(:imageLinks, :thumbnail)
    }
    flash.now.notice = '書籍情報を取得しました。'

    #turbo streamsのリクエストに対するレスポンス
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
    #クリックした書籍のidから詳細情報を表示する
    @book = Book.find(params[:id])
    #該当書籍のレビューを全件取得する
    @reviews = @book.reviews.page(params[:page]).per(5)

    #フォーム生成のため空のreviewオブジェクトを渡す
    @review = Review.new

    #お気に入り登録をしている場合のみ、likesテーブルからログインユーザーと書籍のidに合致するレコードを取得し@likeに格納する
    #レコードを取得することで、お気に入り解除時にdestroyアクションにレコードのidを渡すことができる
    puts "お気に入り有無の判定"
    if Like.liked_by?(@book, current_user)
      @like = Like.find_by(user_id: current_user.id, book_id: @book.id)
      p @like.id
    else
      puts "お気に入りされてません" and return
    end
    puts "お気に入り判定終了"

    #現在お気に入りされている数を数える
    @likes_count = Like.currently_likes(@book.id).count
    puts "お気に入りの数は#{@likes_count}"
  end

  private
  def book_params
    params.require(:book).permit(:title, :author, :description, :image_link)
  end

  def check_ability
    authorize! :access, :books_search
  end
end
