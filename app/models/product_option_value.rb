class ProductOptionValue < ApplicationRecord
  belongs_to :product_option

  has_many :variant_option_values, dependent: :destroy
end
