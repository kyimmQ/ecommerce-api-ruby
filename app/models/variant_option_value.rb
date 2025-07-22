class VariantOptionValue < ApplicationRecord
  belongs_to :product_variant
  belongs_to :product_option_value

  validates :product_variant_id, :product_option_value_id, presence: true
end
