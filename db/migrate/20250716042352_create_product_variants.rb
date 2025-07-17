class CreateProductVariants < ActiveRecord::Migration[7.2]
  def change
    create_table :product_variants do |t|
      t.string :sku
      t.decimal :price
      t.integer :stock_quantity
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
