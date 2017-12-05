class PaymentsController < ApplicationController

  # CSRS token, alipay_notify是通过Post请求发送的数据, 因此需要关闭Rails默认的CSRS token攻击功能
  protect_from_forgery except: [:alipay_notify]

  # => 异步后台通知, 不需要验证用户登录
  # => pay_notify是通过get请求发送的通知!
  before_action :auth_user, except: [:pay_notify]
  # before_action :auth_user, except: [:alipay_notify]

  # => pay_return: 同步通知. 当用户支付成功之后, 支付宝将用户重定向pay_return地址.
  # => pay_notify: 异步通知. 可以多次调用
  # before_action :auth_request, only: [:pay_return, :pay_notify]
  # before_action :auth_request, only: [:pay_notify]
  # before_action :find_and_validate_payment_no, only: [:pay_return, :pay_notify]

  # 进入付款页面(payments_path)点击付款之后, 是向payment_url发送一个post请求, 将pay_options中的字段发送给支付宝
  # ENV中有两个通知地址, 支付宝处理完付款操作之后, RailsJ就会跳转到return_url, 此时是同步通知用户, 付款成功与否
  # 成功付款之后, 就会跳转到 success_payments_path

  # 异步通知暂时还不清楚在哪里调用
  # ENV['ALIPAY_RETURN_URL'] = 'http://localhost:3000/payments/pay_return'
  # ENV['ALIPAY_NOTIFY_URL'] = 'http://localhost:3000/payments/pay_notify'


  def index
    @payment = current_user.payments.find_by(payment_no: params[:payment_no])
    # 支付宝支付网关页面地址
    # @payment_url = build_payment_url
    # 根据记录, 封装所有的需要传递给支付宝的参数
    # @pay_options = build_request_options(@payment)
    # byebug
    @payment_url = $alipay.page_execute_url(
      method: 'alipay.trade.page.pay',
      return_url: ENV['ALIPAY_NOTIFY_URL'],
      notify_url: ENV['ALIPAY_RETURN_URL'],
      biz_content: {
       out_trade_no: @payment.payment_no,
       product_code: 'FAST_INSTANT_TRADE_PAY',
       total_amount: '0.01',
       subject: '支付功能沙箱测试'
      }.to_json
    )

    # redirect_to @payment_url
  end

  def generate_pay
    orders = current_user.orders.where(order_no: params[:order_nos].split(','))
    payment = Payment.create_from_orders!(current_user, orders)

    # 从创建订单到确认支付, 先跳转到generate_pay_payments_path,在此controller下生成payment, 再跳到index页面
    redirect_to payments_path(payment_no: payment.payment_no)
  end

  # 是页面的跳转
  def pay_return
    do_payment
  end

  def pay_notify
    # do_payment
    Rails.logger.info "params: #{params.to_hash}"
    # 去除 controller 以及 action 参数
    notify_params = params.except(*request.path_parameters.keys)
    Rails.logger.info "notify_params: #{notify_params.to_hash}"

    if $alipay.verify?(params)
      Rails.logger.info "alipay return data is verify"
      redirect_to success_payments_path
    else
      Rails.logger.info "alipay return data is not verify"
      redirect_to failed_payments_path
    end
  end

  # 支付宝异步消息接口
  def alipay_notify
    Rails.logger.info "PAYMENT DEBUG NON ALIPAY REQUEST: #{params.to_hash}"
    notify_params = params.except(*request.path_parameters.keys)
    Rails.logger.info "PAYMENT DEBUG NON ALIPAY REQUEST: #{notify_params.to_hash}"
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
        @payment.do_success_payment! params
        redirect_to success_payments_path
      else
        @payment.do_failed_payment! params
        redirect_to failed_payments_path
      end
    else
     redirect_to success_payments_path
    end
  end

  # def auth_request
  #   unless build_is_request_from_alipay?(params)
  #     Rails.logger.info "PAYMENT DEBUG NON ALIPAY REQUEST: #{params.to_hash}"
  #     redirect_to failed_payments_path
  #     return
  #   end

  #   unless build_is_request_sign_valid?(params)
  #     Rails.logger.info "PAYMENT DEBUG ALIPAY SIGN INVALID: #{params.to_hash}"
  #     redirect_to failed_payments_path
  #   end
  # end

  def auth_request
    # @client.verify?(request.query_parameters)
    # => true / false
    unless $alipay.verify?(params)
      # render plain: 'success'
      Rails.logger.info "PAYMENT DEBUG $alipay not verify!!"
      Rails.logger.info "PAYMENT DEBUG NON ALIPAY REQUEST: #{params.to_hash}"
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

  def build_request_options payment
    # opts:
    #   service: create_direct_pay_by_user | mobile.securitypay.pay
    #   sign_type: MD5 | RSA
    pay_options = {
      "service" => 'create_direct_pay_by_user',
      "partner" => ENV['ALIPAY_PID'],
      "seller_id" => ENV['ALIPAY_PID'],
      "payment_type" => "1",
      # 必须设置为绝对地址, 包含http的
      "notify_url" => ENV['ALIPAY_NOTIFY_URL'],
      "return_url" => ENV['ALIPAY_RETURN_URL'],

      "anti_phishing_key" => "",
      "exter_invoke_ip" => "",
      "out_trade_no" => payment.payment_no,
      "subject" => "蛋人商城商品购买",
      "total_fee" => payment.total_money,
      "body" => "蛋人商城商品购买",
      "_input_charset" => "utf-8",
      "sign_type" => 'MD5',
      "sign" => ""
    }

    pay_options.merge!("sign" => build_generate_sign(pay_options))
    pay_options
  end

  def build_payment_url
    "#{ENV['ALIPAY_URL']}?_input_charset=utf-8"
  end

  def build_is_request_from_alipay? result_options
    return false if result_options[:notify_id].blank?

    body = RestClient.get ENV['ALIPAY_URL'] + "?" + {
      service: "notify_verify",
      partner: ENV['ALIPAY_PID'],
      notify_id: result_options[:notify_id]
    }.to_query

    body == "true"
  end

  def build_is_request_sign_valid? result_options
    options = result_options.to_hash
    options.extract!("controller", "action", "format")

    if options["sign_type"] == "MD5"
      options["sign"] == build_generate_sign(options)
    elsif options["sign_type"] == "RSA"
      build_rsa_verify?(build_sign_data(options.dup), options['sign'])
    end
  end

  def build_generate_sign options
    sign_data = build_sign_data(options.dup)

    if options["sign_type"] == "MD5"
      Digest::MD5.hexdigest(sign_data + ENV['ALIPAY_MD5_SECRET'])
    elsif options["sign_type"] == "RSA"
      build_rsa_sign(sign_data)
    end
  end

  # RSA 签名
  def build_rsa_sign(data)
    private_key_path = Rails.root.to_s + "/config/.alipay_self_private"
    pri = OpenSSL::PKey::RSA.new(File.read(private_key_path))

    signature = Base64.encode64(pri.sign('sha1', data))
    signature
  end

  # RSA 验证
  def build_rsa_verify?(data, sign)
    public_key_path = Rails.root.to_s + "/config/.alipay_public"
    pub = OpenSSL::PKey::RSA.new(File.read(public_key_path))

    digester = OpenSSL::Digest::SHA1.new
    sign = Base64.decode64(sign)
    pub.verify(digester, sign, data)
  end

  def build_sign_data data_hash
    data_hash.delete_if { |k, v| k == "sign_type" || k == "sign" || v.blank? }
    data_hash.to_a.map { |x| x.join('=') }.sort.join('&')
  end
end
