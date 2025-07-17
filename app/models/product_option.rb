class ProductOption < ApplicationRecord
  has_many :category_product_options, dependent: :destroy
  has_many :categories, through: :category_product_options

  has_many :product_option_values, dependent: :destroy
end
