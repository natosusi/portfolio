class UsersController < ApplicationController
  #before_action :set_user, only: %i[ edit update destroy ]
  before_action :authenticate_user!
  # GET /users or /users.json
  def index
    puts "indexが呼び出された"
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    puts "showが呼び出された"
    puts params
    #ログイン中の会員idに紐づいた貸出情報と書籍情報を取得する。
    @user = User.includes(lendings: :book).find(params[:id])
    @lending = @user.lendings.currently_lendings
  end
=begin
  # GET /users/new
  def new
    puts "newが呼び出された"
    puts params

    @user = User.new
  end

  # GET /users/1/edit
  def edit
    puts "editが呼び出された"
  end

  # POST /users or /users.json
  def create
    puts "createが呼び出された"
    #新しいUserインスタンスを作成。
    @user = User.new(user_params)

    respond_to do |format|
      #ユーザー情報を保存した時
      if @user.save
        #新規作成したユーザーでログインする。
        log_in @user
        #ユーザー詳細ページにリダイレクトし、フラッシュメッセージを表示する。
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        #新規作成フォームを表示、status:でHTTPステータスコード422を設定する。
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    puts "updateが呼び出された"

    respond_to do |format|
      #respond_toはリクエストの形式（HTMLやJSON等）に応じて異なるレスポンスを返すメソッド
      if @user.update(user_params)
        #フォームから受け取ったパラメータ(user_params)を使って更新する。
        #更新後にユーザー詳細ページにリダイレクトする。noticeでフラッシュメッセージを表示する。
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        #更新失敗の場合、再度編集ページを表示、status:でHTTPステータスコード422を設定する。
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    puts "destroyが呼び出された"
    #destroy!メソッドで削除に失敗したときは例外(ActiveRecord::RecordNotDestroyed)を発生させる。
    #destroyのみだとfalseが返されるのみで例外は発生しない。
    @user.destroy!
    respond_to do |format|
      #ユーザー一覧ページにリダイレクト、seeotherを設定することでgetメソッドでユーザー一覧ページにアクセス
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end
=end
=begin
  def login_form
    puts "login_formが呼び出された"
  end

  def login
    puts "loginが呼び出された"

    @user = User.find_by(name: params[:name],address: params[:address])
    if @user
      session[:user_id] = @user.id

      flash[:notice] = "ログイン完了"
      redirect_to "/users"
    else
      flash[:alert] = "ログイン失敗"
      @name = params[:name]
      @address = params[:address]
      render "users/login_form", status: :unprocessable_entity
    end
  end

  def logout
    puts "logoutが呼び出された"

    reset_session
    flash[:notice] = "ログアウト完了"
    redirect_to "/", status: :see_other
  end
=end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      puts "set_userが呼び出された"
      puts params[:id]
      puts params

      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      puts "user_paramsが呼び出された"

      params.require(:user).permit(:name)
    end
end
