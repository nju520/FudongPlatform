class Seller::BaseController < ActionController::Base

  layout 'seller/layouts/seller'

  include DealCookieable

  before_action :set_browser_uuid
  before_action :auth_seller

  private
  def auth_seller
    unless logged_in? and current_user.is_seller?
      flash[:notice] = "请以商家身份登录"
      redirect_to seller_login_path
    end
  end

  def fetch_home_data
    @categories = Category.grouped_data
    @shopping_cart_count = ShoppingCart.by_user_uuid(session[:user_uuid]).count
  end
end
