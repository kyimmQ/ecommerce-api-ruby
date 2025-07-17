class ProductReview < ApplicationRecord
  belongs_to :product_variant
  belongs_to :user
end
