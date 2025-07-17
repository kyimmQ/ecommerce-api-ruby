class ChangeProductOptionFk < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :product_options, :products
    # ✅ Now remove the column
    remove_column :product_options, :product_id, :bigint

    add_reference :product_options, :category, foreign_key: false

    add_foreign_key :product_options, :categories, null: false, on_delete: :cascade

  end
end
