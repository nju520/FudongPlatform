class AddPaymentMainOrderIdColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :main_order_id, :integer

    add_index :payments, [:main_order_id]
  end
end
