class CreateProductReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :product_reviews do |t|
      t.integer :rating
      t.text :comment
      t.references :product_variant, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
