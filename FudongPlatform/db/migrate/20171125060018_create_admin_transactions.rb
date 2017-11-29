class CreateAdminTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_transactions do |t|
      t.integer :admin_account_id
      t.integer :order_id
      t.string  :transction_no
      t.string  :transction_type
      t.decimal :trade_amount, precision: 10, scale: 2
      t.timestamps
    end

    add_index :admin_transactions, [:admin_account_id]
    add_index :admin_transactions, [:order_id]
    add_index :admin_transactions, [:transction_no], unique: true
  end
end
