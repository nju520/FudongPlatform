class CreatePackOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :pack_orders do |t|
      t.integer :seller_id
      t.integer :main_order_id
      t.string  :pack_order_no
      t.decimal :pack_total_money, precision: 10, scale: 2, default: 0.00
      t.datetime :payment_at
      t.timestamps
    end

    add_index :pack_orders, [:seller_id]
    add_index :pack_orders, [:main_order_id]
    add_index :pack_orders, [:pack_order_no], unique: true
  end
end
