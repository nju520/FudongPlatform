class Admin::ProductsController < Admin::BaseController

  def index
    @products = Product.page(params[:page] || 1).per_page(params[:per_page] || 10)
      .order("id desc")
  end

  def show
    @product = Product.find(params[:id])
    @categories = Category.grouped_data
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:notice] = "删除成功"
      redirect_to admin_products_path
    else
      flash[:notice] = "删除失败"
      redirect_to :back
    end
  end

end
