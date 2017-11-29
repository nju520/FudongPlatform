class Seller::HomeController < Seller::BaseController

  def index
    @categories = Category.grouped_data

    @products = current_user.products
      .page(params[:page] || 1).per_page(params[:per_page] || 12)
      .order("id desc").includes(:main_product_image)
  end
end
