class CreateSellerAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :seller_accounts do |t|
      t.integer :user_id
      t.string :name
      t.string  :account_no
      t.decimal :balance, precision: 10, scale: 2
      t.timestamps
    end

    add_index :seller_accounts, [:user_id]
    add_index :seller_accounts, [:account_no], unique: true
  end
end
