class Admin::ProductImagesController < Admin::BaseController

  before_action :set_product

  def index
    @product_images = @product.product_images
  end

  private
  def set_product
    @product = Product.find params[:product_id]
  end
  
end
