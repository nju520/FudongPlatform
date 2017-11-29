class UsersController < ApplicationController

  def new
    if logged_in?
      flash[:notice] = "已经登录, 无法重复注册"
      redirect_to root_path
    end
    @user = User.new
  end

  def create
    @user = User.create(params.require(:user)
      .permit(:email, :password, :password_confirmation))
    @user.uuid = session[:user_uuid]

    if @user.save
      login(params[:user][:email], params[:user][:password])
      update_browser_uuid(@user.uuid)
      flash[:notice] = "注册成功，跳过邮箱验证"
      redirect_to root_path
    else
      render action: :new
    end
  end

end
