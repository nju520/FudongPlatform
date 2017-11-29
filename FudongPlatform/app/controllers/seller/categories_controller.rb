class Seller::CategoriesController < Seller::BaseController

  def index
    if params[:id].blank?
      @categories = Category.roots
    else
      @category = Category.find(params[:id])
      @categories = @category.children
    end

    @categories = @categories.page(params[:page] || 1).per_page(params[:per_page] || 10)
      .order(id: "desc")
  end

  def show
    @categories = Category.grouped_data
    @category = Category.find(params[:id])
    @products = current_user.products.where(category_id: @category.id)
    @products = @products.page(params[:page] || 1).per_page(params[:per_page] || 12)
      .order("id desc").includes(:main_product_image)
  end

end
