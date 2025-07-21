class ProductVariant < ApplicationRecord
  after_create :auto_sku

  belongs_to :product

  has_many :product_reviews, dependent: :destroy
  has_many :variant_option_values, dependent: :destroy

  def auto_sku
    # Generate a SKU based on the product ID and variant options
    self.sku = "#{product.name.parameterize}-#{variant_option_values.count}"
  end
end
