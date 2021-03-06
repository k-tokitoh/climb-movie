class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインに成功しました。'    #views/layouts/application.html.erbで表示
      redirect_to '/'
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:admin] = nil
    flash[:success] = 'ログアウトしました。'
    redirect_to '/'
  end
  
  private

  # def createで利用する
  def login(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      # ログイン成功
      session[:user_id] = @user.id
      session[:admin] = @user.admin
      return true
    else
      # ログイン失敗
      return false
    end
  end
end
