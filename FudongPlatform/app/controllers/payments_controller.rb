class PaymentsController < ApplicationController

  before_action :auth_user

  def index
  end

  def new
    @main_order = current_user.main_orders.find_by(main_order_no: params[:main_order_no])
    @payment = current_user.payments.new
  end

  def show
    @payment = Payment.find(params[:id])
  end

  def create
    main_order = current_user.main_orders.find_by(main_order_no: params[:main_order_no])
    # byebug
    @payment = Payment.create_from_main_order!(current_user, main_order)
    @payment.do_success_payment!
    redirect_to payment_path(@payment.id)
  end

end
