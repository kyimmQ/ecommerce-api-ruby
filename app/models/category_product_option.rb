class CategoryProductOption < ApplicationRecord
  belongs_to :category
  belongs_to :product_option

  validates :category_id, :product_option_id, presence: true
  validates :category_id, uniqueness: { scope: :product_option_id }
end
