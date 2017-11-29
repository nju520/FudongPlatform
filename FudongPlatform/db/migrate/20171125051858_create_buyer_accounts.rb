class CreateBuyerAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :buyer_accounts do |t|
      t.integer :user_id
      t.string :name
      t.string  :account_no
      t.decimal :balance, precision: 10, scale: 2, default: 0.00
      t.timestamps
    end

    add_index :buyer_accounts, [:user_id]
    add_index :buyer_accounts, [:account_no], unique: true
  end
end
