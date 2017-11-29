module Noticable
  extend ActiveSupport::Concern

  # 下单通知
  def buy_notice
    buyer = self.user
    seller = self.seller
    ActionCable.server.broadcast("user_#{seller.uuid}", message: "您有来自#{buyer.username}的订单")
    notice_admin("平台有来自#{buyer.username}的订单")
  end

  # 付款通知
  def pay_notice
    buyer = self.user
    seller = self.seller
    ActionCable.server.broadcast("user_#{seller.uuid}", message: "来自#{buyer.username}的订单已付款")
    notice_admin("来自#{buyer.username}的订单已付款")
  end

  # 发货通知
  def ship_notice
    buyer = self.user
    ActionCable.server.broadcast("user_#{buyer.uuid}", message: "您的货物#{self.product.title}已发货")
    notice_admin("商家#{seller.username}的#{self.product.title}已发货")
  end

  # 收货通知
  def receive_notice
    seller = self.seller
    ActionCable.server.broadcast("user_#{seller.uuid}", message: "您的买家#{self.user.username}已确认收货")
    notice_admin("买家#{self.user.username}已确认收货")
  end

  # 平台打钱给商家通知
  def remit_notice
    seller = self.seller
    ActionCable.server.broadcast("user_#{seller.uuid}", message: "平台已向您打款")
    # buyer = self.user
    # ActionCable.server.broadcast("user_#{buyer.uuid}", message: "平台已向商家#{seller.username}打款")
  end

  protected
  def notice_admin(message)
    admins = User.all.where(is_admin: true)
    admins.each do |admin|
      ActionCable.server.broadcast("user_#{admin.uuid}", message: message)
    end
  end
end
