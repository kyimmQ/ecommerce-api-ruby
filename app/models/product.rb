class Product < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :category

  has_many :product_variants, dependent: :destroy

  validates :name, :description, :category_id, :owner_id, presence: true
  validates :image_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true

  def available_options
    category.all_product_options
  end

  def price_range
    product_variants.pluck(:price).minmax
  end

  def all_variants
    product_variants.includes(:product_reviews, variant_option_values: { product_option_value: :product_option }).map do |variant|
      {
        id: variant.id,
        sku: variant.sku,
        price: variant.price,
        stock_quantity: variant.stock_quantity,
        option_values: variant.variant_option_values.map do |vov|
          {
            option_name: vov.product_option_value.product_option.name,
            value: vov.product_option_value.value
          }
        end
      }
    end
  end
end
