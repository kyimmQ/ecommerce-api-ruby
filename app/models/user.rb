class User < ApplicationRecord
  before_save :create_shopping_cart

  has_secure_password
  validates :name, :address, :email, :phone, presence: true
  validates :email, uniqueness: true

  # roles -> permissions
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :permissions, through: :roles
  # products
  has_many :products, foreign_key: :owner_id
  # reviews
  has_many :product_reviews, foreign_key: :user_id
  # Orders
  has_many :orders, foreign_key: :user_id
  # Shopping Cart
  has_one :shopping_cart, dependent: :destroy

  def can?(permission_name)
    permissions.exists?(name: permission_name)
  end

  def have_cart_item?(product_variant_id)
    cart_items = shopping_cart.cart_items || []
    cart_items.any? { |item| item.product_variant_id == product_variant_id }
  end

  def create_shopping_cart
    self.create_shopping_cart
  end
end
