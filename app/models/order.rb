class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :product_variants, through: :order_items

  validates :status, :user_id, :total_price, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  enum status: { pending: 0, paid: 1, completed: 2, cancelled: 3, returned: 4 }

  # Associations

  belongs_to :user
end
