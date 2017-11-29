class BuyerTransaction < ApplicationRecord
  include GenNumberable
  
  belongs_to :buyer_account
  belongs_to :order

  before_create do
    gen_no("transction_no", "generate_utoken", 32)
  end

end
