class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include DealCookieable

  before_action :set_browser_uuid

  protected
  def auth_user
    unless logged_in?
      flash[:notice] = "请先登录"
      redirect_to new_session_path
    end
  end

  def fetch_home_data
    @categories = Category.grouped_data
    @shopping_cart_count = ShoppingCart.by_user_uuid(session[:user_uuid]).count
  end

end
