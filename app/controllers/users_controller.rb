class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    puts "indexが呼び出された"
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    puts "showが呼び出された"
    puts params
  end

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

    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    puts "updateが呼び出された"

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    puts "destroyが呼び出された"

    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

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

      params.require(:user).permit(:name, :age, :address)
    end
end
