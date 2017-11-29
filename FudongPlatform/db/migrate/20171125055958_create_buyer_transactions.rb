class CreateBuyerTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :buyer_transactions do |t|
      t.integer :buyer_account_id
      t.integer :order_id
      t.string  :buyer_name
      t.string  :transction_no
      t.string  :transction_type
      t.decimal :trade_amount, precision: 10, scale: 2
      t.timestamps
    end

    add_index :buyer_transactions, [:buyer_account_id]
    add_index :buyer_transactions, [:order_id]
    add_index :buyer_transactions, [:transction_no], unique: true
  end
end
