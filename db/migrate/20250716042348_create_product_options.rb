class CreateProductOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :product_options do |t|
      t.string :name
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
