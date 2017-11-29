class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.integer :category_id
      # 所属商家
      t.integer :seller_id
      # 名称
      t.string :title
      # 商品状态: 上架on/下架off
      t.string :status, default: 'off'
      # 商品库存数量
      t.integer :amount, default: 0
      # 序列号
      t.string :uuid
      # 市场零售价
      t.decimal :msrp, precision: 10, scale: 2
      # 销售价格
      t.decimal :price, precision: 10, scale: 2
      # 商品描述
      t.text :description
      t.timestamps
    end

    add_index :products, [:status, :category_id]
    add_index :products, [:category_id]
    add_index :products, [:seller_id]
    add_index :products, [:uuid], unique: true
    add_index :products, [:title]
  end
end
