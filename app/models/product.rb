class Product < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :category

  has_many :product_variants, dependent: :destroy

  validates :name, presence: true

  def available_options
    category.all_product_options
  end

  def price_range
    product_variants.pluck(:price).minmax
  end

  def all_variants
    product_variants.includes(:product_reviews).map do |variant|
      {
        id: variant.id,
        sku: variant.sku,
        price: variant.price,
        stock_quantity: variant.stock_quantity
      }
    end
  end
end
