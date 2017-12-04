class Dashboard::OrdersController < Dashboard::BaseController

  def index
    @orders = current_user.orders.page(params[:page] || 1).per_page(params[:per_page] || 10)
       .includes([[:product => [:main_product_image]], :address]).order("id desc")
    @payment = Payment.new
  end

  def update
    order = Order.find(params[:id])
    order.update_attribute(:status, Order::OrderStatus::Received)
    order.receive_notice
    redirect_to dashboard_orders_path
  end

end
