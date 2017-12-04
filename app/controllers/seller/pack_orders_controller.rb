class Seller::PackOrdersController < Seller::BaseController

  def index
    @pack_orders = PackOrder.includes(orders: [{product: :main_product_image}, :address])
      .where({products: {seller_id: current_user.id}}).distinct
      .page(params[:page] || 1).per_page(params[:per_page] || 10)
      .order("orders.id desc")
  end

  
end
