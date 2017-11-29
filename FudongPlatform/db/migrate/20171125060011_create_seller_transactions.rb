class CreateSellerTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :seller_transactions do |t|
      t.integer :seller_account_id
      t.integer :order_id
      t.string  :seller_name
      t.string  :transction_no
      t.string  :transction_type
      t.decimal :trade_amount, precision: 10, scale: 2
      t.timestamps
    end

    add_index :seller_transactions, [:seller_account_id]
    add_index :seller_transactions, [:order_id]
    add_index :seller_transactions, [:transction_no], unique: true
  end
end
