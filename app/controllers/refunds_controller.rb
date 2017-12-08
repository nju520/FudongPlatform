class RefundsController < ApplicationController
  before_action :set_order, only: [:new]
  def new
  end

  def create
    @order = Order.find(params[:order_id])
    response = $alipay.excute(refund_params)
    result = JSON.parse(response['alipay_trade_refund_response'])

    byebug
    redirect_to dashboard_orders_path
  end

  def show

  end

  private
  def refund_params
    {
      method: 'alipay.trade.refund',
      biz_content: {
        out_trade_no: params[:payment_no],
        refund_amount: params[:total_money]
      }.to_json
    }
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
