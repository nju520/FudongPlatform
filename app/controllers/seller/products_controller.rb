class Seller::ProductsController < Seller::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = current_user.products.page(params[:page] || 1).per_page(params[:per_page] || 10)
      .order("id desc")
  end

  def new
    @product = current_user.products.new
    @root_categories = Category.roots
  end

  def create
    @root_categories = Category.roots
    @product = current_user.products.new(product_params)
    if @product.save
      flash[:notice] = "创建商品成功, 请上传商品图片"
      redirect_to seller_products_path
    else
      render action: :new
    end
  end

  def show
    @categories = Category.grouped_data
  end

  def edit
    @root_categories = Category.roots
    render action: :new
  end

  def update
    @root_categories = Category.roots
    if @product.update_attributes(product_params)
      flash[:notice] = "修改成功"
      redirect_to seller_products_path
    else
      render action: :new
    end
  end

  def destroy
    if @product.destroy
      flash[:notice] = "删除成功"
      redirect_to seller_products_path
    else
      flash[:notice] = "删除失败"
      redirect_to :back
    end
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit!
  end

end
