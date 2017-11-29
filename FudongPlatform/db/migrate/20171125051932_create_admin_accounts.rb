class CreateAdminAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_accounts do |t|
      t.string :name
      t.string  :account_no
      t.decimal :balance, precision: 10, scale: 2
      t.timestamps
    end

    add_index :admin_accounts, [:account_no], unique: true
  end
end
