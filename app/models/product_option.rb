class ProductOption < ApplicationRecord
  belongs_to :category

  has_many :product_option_values, dependent: :destroy
end
