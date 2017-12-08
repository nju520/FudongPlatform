class PaymentsController < ApplicationController

  protect_from_forgery except: [:pay_notify]
  before_action :auth_user, except: [:pay_notify]

  # 验证异步通知是否合法 pay_notify
  before_action :auth_request, only: [:pay_return, :pay_notify]
  before_action :find_and_validate_payment_no, only: [:pay_return, :pay_notify]

  # 进入付款页面(payments_path)点击付款之后, 是向payment_url发送一个请求
  # ENV中有两个通知地址, 支付宝处理完付款操作之后, RailsJ就会跳转到return_url, 此时是同步通知用户, 付款成功与否
  # 成功付款之后, 就会跳转到 success_payments_path
  # 后台处理支付宝的异步通知, 异步通知向notify_url发送post请求, 如果验证支付宝返回的数据合法, 支付的金额和订单号等也没有问题, 就返回字符串'success', 否则支付宝就会不断发送post请求

  def index
    @payment = current_user.payments.find_by(payment_no: params[:payment_no])
    # byebug
    @payment_url = $alipay.page_execute_url(
      method: 'alipay.trade.page.pay',
      return_url: ENV['ALIPAY_RETURN_URL'],
      notify_url: ENV['ALIPAY_NOTIFY_URL'],
      biz_content: {
       out_trade_no: @payment.payment_no,
       product_code: 'FAST_INSTANT_TRADE_PAY',
       total_amount: @payment.total_money,
       subject: '支付功能沙箱测试'
      }.to_json
    )
  end

  def generate_pay
    orders = current_user.orders.where(order_no: params[:order_nos].split(','))
    payment = Payment.create_from_orders!(current_user, orders)
    # 从创建订单到确认支付, 先跳转到generate_pay_payments_path,在此controller下生成payment, 再跳到index页面
    redirect_to payments_path(payment_no: payment.payment_no)
  end

  # 是页面的跳转
  def pay_return
    # TODO
    # verify
    # Rails.logger.info "alipay return params: #{params.to_hash}"
    redirect_to success_payments_path
  end

  def pay_notify
    do_payment
    # 成功接收消息后，需要返回纯文本的 ‘success’，否则支付宝会定时重发消息，最多重试7次。
    render plain: 'success'
  end

  # 支付宝异步消息接口
  def alipay_notify
    notify_params = params.except(*request.path_parameters.keys)
    # 先校验消息的真实性
    if $alipay.verify?(notify_params)
      # 获取交易关联的订单
      # @order = Order.find params[:out_trade_no]
      @payment = Payment.find_by_payment_no params[:out_trade_no]

      case params[:trade_status]
      when 'WAIT_BUYER_PAY'
        # 交易开启
        # @order.update_attribute :trade_no, params[:trade_no]
        # @order.pend
      when 'WAIT_SELLER_SEND_GOODS'
        # 买家完成支付
        # @order.pay
        # 虚拟物品无需发货，所以立即调用发货接口
        # @order.send_good
      when 'TRADE_FINISHED'
        # 交易完成
        # @order.complete
      when 'TRADE_CLOSED'
        # 交易被关闭
        # @order.cancel
      end

      do_payment
      render :text => 'success' # 成功接收消息后，需要返回纯文本的 ‘success’，否则支付宝会定时重发消息，最多重试7次。
    else
      render :text => 'error'
    end
  end

  def success

  end

  def failed

  end

  private
  # 支付完毕返回的参数params中有params[:trade_status]
  def is_payment_success?
    %w[TRADE_SUCCESS TRADE_FINISHED].include?(params[:trade_status])
  end

  def do_payment
    unless @payment.is_success? # 避免同步通知和异步通知多次调用
      if is_payment_success?
        @payment.do_success_payment!
        # redirect_to success_payments_path
      else
        @payment.do_failed_payment! params
        # redirect_to failed_payments_path
      end
    else
    #  redirect_to success_payments_path
    end
  end


  def auth_request
    notify_params = params.except(*request.path_parameters.keys)
    unless $alipay.verify?(notify_params)
      Rails.logger.info "++++ alipay verify failed"
      redirect_to failed_payments_path
    end
  end

  def find_and_validate_payment_no
    @payment = Payment.find_by_payment_no params[:out_trade_no]
    unless @payment
      if is_payment_success?
        # TODO
        render text: "未找到支付单号，但是支付已经成功"
        return
      else
        render text: "未找到您的订单号，同时您的支付没有成功，请返回重新支付"
        return
      end
    end
  end

end
