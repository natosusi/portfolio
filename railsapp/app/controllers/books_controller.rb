class BooksController < ApplicationController
  def search
    puts "searchが呼び出された"
    @isbn = params[:isbn].to_s.strip

    #isbnコードの値が正しいか判定する
    #判定1:変数isbnの値が存在しているが、データが空の場合、処理が停止する。
    puts "判定開始"
    if !@isbn.present?
      puts "判定1が実行されてるよ"
      return
      #判定2:変数isbnの値が存在していて、13桁の数字ではない場合、処理が停止する。アラートを表示して変数isbnを空にする。
    elsif !@isbn.match?(/\A\d{13}\z/)
      puts "判定2が実行されてるよ"
      @isbn = ""
      p @isbn
      flash.now[:alert] = '13桁のISBNコードを正しく入力してください。'
      render :search, status: :unprocessable_entity and return
    end
    puts "判定完了"

    #APIキーを環境変数から取得する
    api_key = ENV['GOOGLE_BOOKS_API_KEY']

    #ベースURLの設定
    conn = Faraday.new(url: "https://www.googleapis.com") do |f|
      #リクエストボディをJSON文字列にエンコード。
      #parser_optionsで文字列をオブジェクトに変換、シンボル化する。
      f.response :json, parser_options: { symbolize_names: true }
    end
    #APIリクエストの送信
    res = conn.get("/books/v1/volumes", {q: "isbn:#{@isbn}", country: "JP", key: api_key})

    p res
    #APIリクエストが成功、レスポンスボディにitemsがあり、その中に1つ以上要素がある場合
    if res.success? && res.body[:items]&.any?
      puts "APIから取得できたよ"
      #itemsの先頭のvolumeInfo(書籍情報)をvolumeに格納
      volume = res.body[:items].first[:volumeInfo]

      p volume

      @book_info = { 
        title: volume[:title],
        authors: volume[:authors]&.join(','),
        description: volume[:description],
        image: volume.dig(:imageLinks, :thumbnail)
      }

      puts @book_info
    else
      puts "APIから取得できてないよ"
      flash.now[:alert] = '書籍情報を取得できませんでした'
      @book_info = nil
    end

    #turbo streamsのリクエストに対するレスポンス
    respond_to do |format|
      format.html { render search_books_path }
      format.turbo_stream
    end

  end

  def create
  end
end
