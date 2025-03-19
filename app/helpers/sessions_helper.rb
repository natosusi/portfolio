module SessionsHelper
  #渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  #現在ログイン中のユーザー情報を取得する
  #セッションにユーザーIDが存在する場合のみ、@current_userがnilであれば、そのIDを使ってユーザーを検索し、結果を変数@current_userに代入する
  def current_user
    @current_user ||=  User.find_by(id: session[:user_id]) if session[:user_id]
  end

  #真偽値を返すメソッド
  def logged_in?
    #current_userがnilかそうでないか(ログインしているか否か)をチェックし、結果を論理否定[!]する。nil(ログイン済み)のときはfalse、nilじゃないとき(ログインしてない)はtrueを返す。
    !current_user.nil?
  end

  #ログアウト処理、セッション情報を削除し、@current_userをnilにする
  def log_out
    reset_session
    @current_user = nil
  end
end
