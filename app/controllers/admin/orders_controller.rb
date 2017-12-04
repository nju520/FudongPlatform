class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.includes([{product: :main_product_image}, :address])
      .page(params[:page] || 1).per_page(params[:per_page] || 10)
      .order("orders.id desc")
  end

  def update
    order = Order.find(params[:id])
    # 平台打款给商家
    AdminAccount.singleton_account.pay_to_seller(order)
    # 记录此订单流水账
    order.save_platform_pay_records(order.seller)
    order.update_attribute(:status, Order::OrderStatus::Received)
    order.remit_notice
    redirect_to admin_orders_path
  end
end
