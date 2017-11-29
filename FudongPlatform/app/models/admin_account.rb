class AdminAccount < ApplicationRecord
  include GenNumberable

  before_create do
    gen_no("account_no", "generate_utoken", 32)
    if AdminAccount.count > 1
      self.errors.add(:base, "already one platform_account existing")
      return false
    end
  end

  has_many :admin_transactions

  def pay_to_seller(order)
    update_attributes(balance: self.balance - order.total_money)
    order.seller.seller_account.update_attributes(balance: self.balance + order.total_money)
  end

  def self.singleton_account
    AdminAccount.first
  end
end
