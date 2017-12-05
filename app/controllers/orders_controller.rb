class OrdersController < ApplicationController

  before_action :auth_user

  def new
    fetch_home_data
    @shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid)
      .order("id desc").includes([:product => [:main_product_image]])
  end

  def create
    shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid).includes(:product)
    if shopping_carts.blank?
      redirect_to shopping_carts_path
      return
    end

    address = current_user.addresses.find(params[:address_id])
    orders = Order.create_order_from_shopping_carts!(current_user, address, shopping_carts)
    orders.each do |order|
      order.buy_notice
    end
    pack_orders = PackOrder.create_pack_order_from_orders!(orders)
    main_order = MainOrder.create_main_order_from_pack_orders!(current_user, pack_orders)
    # redirect_to new_payment_path(main_order_no: main_order.main_order_no)
    redirect_to generate_pay_payments_path(order_nos: orders.map(&:order_no).join(','))
  end

end
