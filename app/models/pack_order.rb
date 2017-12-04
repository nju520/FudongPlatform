class PackOrder < ApplicationRecord
  include GenNumberable

  belongs_to :seller, class_name: 'User', foreign_key: 'user_id', optional: true
  belongs_to :main_order, optional: true
  has_many :orders

  before_create do
    gen_no("pack_order_no", "generate_utoken", 32)
  end

  def self.create_pack_order_from_orders!(orders)
    pack_orders = []
    transaction do
      seller_ids = orders.map {|order| order.product.seller.id}.uniq
      seller_ids.each do |seller_id|
        pack_orders << PackOrder.create(seller_id: seller_id)
      end

      orders.each do |order|
        seller = order.product.seller
        # TODO
        pack_order = pack_orders.find {|pack_order| pack_order.seller_id == seller.id}
        pack_order.update_attributes(
          pack_total_money: pack_order.pack_total_money + order.total_money,
        )
        order.update_attribute(:pack_order_id, pack_order.id)
      end
    end

    pack_orders
  end

  def is_status?(status)
    flag = true
    self.orders.each do |pack_order|
      flag = flag && order.status == status
    end
    flag
  end

  def syn_orders(status)
    self.orders.each do |order|
      order.udpate_attribute(:status, status)
    end
  end
end
