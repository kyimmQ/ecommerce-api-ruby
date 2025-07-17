class ProductVariant < ApplicationRecord
  belongs_to :product

  has_many :product_reviews, dependent: :destroy
  has_many :variant_option_values, dependent: :destroy
end
