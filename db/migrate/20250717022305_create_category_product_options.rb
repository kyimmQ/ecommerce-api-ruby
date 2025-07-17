class CreateCategoryProductOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :category_product_options do |t|
      t.references :category, null: false, foreign_key: true
      t.references :product_option, null: false, foreign_key: true
    end

    add_index :category_product_options, [:category_id, :product_option_id], unique: true
  end
end
