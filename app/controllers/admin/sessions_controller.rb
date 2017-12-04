class Admin::SessionsController < Admin::BaseController
  skip_before_action :auth_admin, only: [:new, :create], raise: false

  def new
  end

  def create
    if user = login(params[:email], params[:password])
      update_browser_uuid user.uuid

      flash[:notice] = "管理员登陆成功"
      redirect_to admin_root_path
    else
      flash[:notice] = "邮箱或者密码不正确"
      redirect_to new_admin_session_path
    end
  end

  def destroy
    logout
    cookies.delete :user_uuid
    flash[:notice] = "退出成功"
    redirect_to admin_login_path
  end
end
