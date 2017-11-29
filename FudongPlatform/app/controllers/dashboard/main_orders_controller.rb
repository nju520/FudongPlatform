class Dashboard::MainOrdersController < Dashboard::BaseController

  def index
    @payment = current_user.payments.new
    @main_orders = current_user.main_orders
      .includes(orders: [{product: :main_product_image}, :address]).order("id desc")
      .page(params[:page] || 1).per_page(params[:per_page] || 10)
  end

end
