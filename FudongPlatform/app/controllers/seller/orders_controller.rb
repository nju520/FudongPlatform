class Seller::OrdersController < Seller::BaseController

  def index
    @orders = Order.includes([{product: :main_product_image}, :address])
      .where({products: {seller_id: current_user.id}})
      .page(params[:page] || 1).per_page(params[:per_page] || 10)
      .order("orders.id desc")
  end

  def update
    order = Order.find(params[:id])
    order.update_attribute(:status, Order::OrderStatus::Shipping)
    order.ship_notice
    redirect_to seller_orders_path
  end
end
