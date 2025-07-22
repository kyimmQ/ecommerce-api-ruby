class CartItem < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :product_variant

  validates :product_variant_id, :shopping_cart_id, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }
end
