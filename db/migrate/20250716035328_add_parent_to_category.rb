class AddParentToCategory < ActiveRecord::Migration[7.2]
  def change
    add_reference :categories, :parent, null: true, foreign_key: { to_table: :categories }
  end
end
