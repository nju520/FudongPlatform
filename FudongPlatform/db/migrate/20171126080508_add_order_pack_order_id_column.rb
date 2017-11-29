class AddOrderPackOrderIdColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :pack_order_id, :integer

    add_index :orders, [:pack_order_id]
  end
end
