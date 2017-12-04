class AddOrdersMainOrderIdColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :main_order_id, :integer

    add_index :orders, [:main_order_id]
  end
end
