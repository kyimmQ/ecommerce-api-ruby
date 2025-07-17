class Category < ApplicationRecord
  after_create :add_default_type_option


  has_many :products, dependent: :nullify

  has_many :product_options, dependent: :destroy
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true

  validates :name, presence: true


  private

  def add_default_type_option
    product_options.find_or_create_by!(name: "Type")
  end

end
