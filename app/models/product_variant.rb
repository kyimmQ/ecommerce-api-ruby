class ProductVariant < ApplicationRecord
  before_save :auto_sku

  belongs_to :product

  has_many :product_reviews, dependent: :destroy
  has_many :variant_option_values, dependent: :destroy
  has_many :product_option_values, through: :variant_option_values
  has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  validates :sku, :price, :product_id, :stock_quantity, presence: true
  validates :sku, uniqueness: true
  def auto_sku
    # Generate a SKU based on the product ID and variant options
    self.sku = "#{product.name.parameterize}-#{variant_option_values.count}"
  end
end
