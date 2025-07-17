class User < ApplicationRecord
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

  def can?(permission_name)
    permissions.exists?(name: permission_name)
  end
end
