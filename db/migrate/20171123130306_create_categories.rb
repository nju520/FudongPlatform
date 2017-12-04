class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      # 分类名称
      t.string :title
      # 权重
      t.integer :weight, default: 0
      # 商品数量
      t.integer :products_counter, default: 0
      t.timestamps
    end

    add_index :categories, [:title]
  end
end
