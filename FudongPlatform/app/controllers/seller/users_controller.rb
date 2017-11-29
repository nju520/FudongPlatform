class Seller::UsersController < Seller::BaseController
  skip_before_action :auth_seller, only: [:new, :create], raise: false

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user)
      .permit(:is_seller, :email, :password, :password_confirmation))
    # uuid关联用户
    @user.uuid = session[:user_uuid]

    if @user.save
      login(params[:user][:email], params[:user][:password])
      update_browser_uuid(@user.uuid)
      flash[:notice] = "注册成功，跳过邮箱验证"
      redirect_to seller_root_path
    else
      render action: :new
    end
  end
end
