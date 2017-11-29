class Seller::ProductImagesController < Seller::BaseController
  before_action :set_product

  def index
    @product_images = @product.product_images
  end

  def create
    params[:images].each do |image|
      @product.product_images << ProductImage.new(image: image)
    end

  redirect_to_back
  end

  def destroy
    @product_image = @product.product_images.find(params[:id])
    if @product_image.destroy
      flash[:notice] = "删除成功"
    else
      flash[:notice] = "删除失败"
    end

    redirect_to_back
  end

  # 修改图片的权重
  def update
    @product_image = @product.product_images.find(params[:id])
    @product_image.weight = params[:weight]
    if @product_image.save
      flash[:notice] = "修改成功"
    else
      flash[:notice] = "修改失败"
    end

    redirect_to_back
  end

  private
  def set_product
    @product = Product.find params[:product_id]
  end

  def redirect_to_back
    redirect_back(fallback_location: seller_product_product_images_path(product_id: @product))
  end

end
