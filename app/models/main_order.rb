class MainOrder < ApplicationRecord
  include GenNumberable

  belongs_to :user
  has_one :payment
  has_many :pack_orders
  has_many :orders

  before_create do
    gen_no("main_order_no", "generate_utoken", 32)
  end

  def self.create_main_order_from_pack_orders!(user, pack_orders)
    main_order = nil
    transaction do
      main_order = user.main_orders.create(
        main_total_money: pack_orders.map(&:pack_total_money).reduce(0.0, &:+),
      )

      pack_orders.each do |pack_order|
        pack_order.update_attribute(:main_order_id, main_order.id)
        pack_order.orders.each do |order|
          order.update_attribute(:main_order_id, main_order.id)
        end
      end
    end

    main_order
  end


  def is_status?(status)
    flag = true
    self.orders.each do |pack_order|
      flag = flag && order.status == status
    end
    flag
  end
end
