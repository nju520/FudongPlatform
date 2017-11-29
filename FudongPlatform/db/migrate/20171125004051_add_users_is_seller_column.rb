class AddUsersIsSellerColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_seller, :boolean, default: false
  end
end
