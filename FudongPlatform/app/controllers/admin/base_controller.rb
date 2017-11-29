class Admin::BaseController < ActionController::Base

  layout 'admin/layouts/admin'

  include DealCookieable

  before_action :set_browser_uuid
  before_action :auth_admin

  private
  def auth_admin
    unless logged_in? and current_user.is_admin?
      flash[:notice] = "请以管理员身份登录"
      redirect_to admin_login_path
    end
  end

  def fetch_home_data
    @categories = Category.grouped_data
    @shopping_cart_count = ShoppingCart.by_user_uuid(session[:user_uuid]).count
  end
end
