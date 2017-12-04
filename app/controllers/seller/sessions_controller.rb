class Seller::SessionsController < Seller::BaseController
  skip_before_action :auth_seller, only: [:new, :create], raise: false

  def new
  end

  def create
    if user = login(params[:email], params[:password])
      # 更新浏览器uuid
      update_browser_uuid user.uuid

      flash[:notice] = "商家登陆成功"
      redirect_to seller_root_path
    else
      flash[:notice] = "邮箱或者密码不正确"
      redirect_to new_seller_session_path
    end
  end

  def destroy
    logout
    cookies.delete :user_uuid
    flash[:notice] = "商家退出成功"
    redirect_to seller_login_path
  end
end
