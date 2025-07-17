class AddCascadeDeleteToCategoryParentId < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :categories, :categories, column: :parent_id

    add_foreign_key :categories, :categories, column: :parent_id, on_delete: :cascade
  end
end
