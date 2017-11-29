class SellerAccount < ApplicationRecord
  include GenNumberable

  belongs_to :seller,->  {where is_seller: true},  class_name: 'User', foreign_key: 'user_id'
  has_many :seller_transactions

  before_create do
    gen_no("account_no", "generate_utoken", 32)
  end
end
