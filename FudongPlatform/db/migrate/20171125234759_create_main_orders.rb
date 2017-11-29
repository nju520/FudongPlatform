class CreateMainOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :main_orders do |t|
      t.integer :user_id
      t.string  :main_order_no
      t.decimal :main_total_money, precision: 10, scale: 2
      t.datetime :payment_at
      t.timestamps
    end

    add_index :main_orders, [:user_id]
    add_index :main_orders, [:main_order_no], unique: true
  end
end
