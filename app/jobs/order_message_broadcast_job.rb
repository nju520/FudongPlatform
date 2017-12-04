class OrderMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(payment)
    payment.orders.each do |order|
      order.pay_notice
    end
  end

end
