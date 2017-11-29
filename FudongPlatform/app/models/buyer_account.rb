class BuyerAccount < ApplicationRecord
  include GenNumberable

  belongs_to :buyer, class_name: 'User', foreign_key: 'user_id'
  has_many :buyer_transactions

  before_create do
    gen_no("account_no", "generate_utoken", 32)
  end

  def pay_to_platform(payment)
    update_attributes(balance: self.balance - payment)
    admin_account = AdminAccount.singleton_account
    admin_account.update_attributes(balance: self.balance + payment)
  end

end
