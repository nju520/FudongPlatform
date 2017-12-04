module Transactable
  extend ActiveSupport::Concern

  def save_buyer_pay_records(user, payment_id)
    self.update_attribute(:payment_id, payment_id)

    # 记录每条order的交易信息
    self.buyer_transactions.create!(
      buyer_account_id: user.buyer_account.id,
      trade_amount: self.total_money,
      transction_type: 'payment_to_platform'
    )

    # TODO
    self.admin_transactions.create!(
      admin_account_id: AdminAccount.singleton_account.id,
      trade_amount: self.total_money,
      transction_type: 'receive_payment_from_user'
    )
  end

  def save_platform_pay_records(seller)
    # TODO
    self.admin_transactions.create!(
      admin_account_id: AdminAccount.singleton_account.id,
      trade_amount: self.total_money,
      transction_type: 'payment_to_seller'
    )
    # 记录每条order的交易信息
    self.seller_transactions.create!(
      seller_account_id: seller.seller_account.id,
      trade_amount: self.total_money,
      transction_type: 'receive_payment_from_platform'
    )
    
  end
end
