class SessionsController < ApplicationController
  def new
  end
=begin
  def create
    puts "createが呼び出された"
    #:sessionキーにネストされたフォームからのログイン情報を検索し、userとして返す
    user = User.find_by(name: params[:session][:name],address: params[:session][:address],password_digest: params[:session][:password_digest])
    if user
      #取得したログイン情報でログイン
      log_in(user)
      flash[:notice] = "ログイン完了"
      redirect_to user
    else
      puts "ログイン失敗"
      flash[:alert] = "ログイン失敗"
      #記入したログイン情報を保持したままログインフォームを表示する
      @name = params[:session][:name]
      @address = params[:session][:address]
      @password_digest = [:session][:password_digest]
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    puts "destroyが呼び出された"
    log_out
    flash[:notice] = "ログアウト完了"
    redirect_to "/", status: :see_other
  end
=end
end
