class Payment < ApplicationRecord
  include GenNumberable

  module PaymentStatus
    Initial = 'initial'
    Success = 'success'
    Failed = 'failed'
  end

  belongs_to :user
  belongs_to :main_order
  has_many :orders

  before_create do
    gen_no("payment_no", "generate_utoken", 32)
  end

  after_create_commit {OrderMessageBroadcastJob.perform_later self}

  def self.create_from_main_order!(user, main_order)
    orders = main_order.orders
    payment = nil
    transaction do
      payment = user.payments.create!(
        main_order_id: main_order.id,
        total_money: main_order.main_total_money
      )

      user.buyer_account.pay_to_platform(payment.total_money)

      # 记录每条订单的交易记录
      orders.each do |order|
        order.save_buyer_pay_records(user, payment.id)
      end
    end

    payment
  end

  def is_success?
    self.status == PaymentStatus::Success
  end

  def do_success_payment!
    self.transaction do
      self.update_attributes(
        status: Payment::PaymentStatus::Success,
        payment_at: Time.now
      )
      # 更新订单状态
      syn_orders(Order::OrderStatus::Paid)
    end
  end

  private
  def syn_orders(status)
    self.orders.each do |order|
      order.update_attribute(:status, status)
    end
  end

end
