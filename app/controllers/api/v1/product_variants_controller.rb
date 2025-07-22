class Api::V1::ProductVariantsController < ApplicationController
  include OwnershipValidatable

  before_action :set_product, :validate_ownership

  def create
    variant = @product.product_variants.new(variant_params)
    puts variant.inspect
    new_option_values = option_values_params[:type].map do |option|
      product_option = ProductOption.find(option[:option_id])
      product_option_value = ProductOptionValue.find_by(product_option: product_option, value: option[:value])
      if product_option_value.nil?
        product_option_value = ProductOptionValue.create!(product_option: product_option, value: option[:value])
        unless product_option_value.save
          render json: { errors: product_option_value.errors }, status: :unprocessable_entity and return
        end
      end
      product_option_value
    end
    variant.product_option_values << new_option_values
    if variant.save
      render json: { data: variant.as_json(include: { variant_option_values: { include: :product_option_value } }), message: "Variant created successfully." }, status: :created
    else
      render json: { errors: variant.errors }, status: :unprocessable_entityß
    end
  end

  def update

  end

  def destroy

  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end

  def variant_params
    params.permit(:price, :stock_quantity)
  end

  def option_values_params
    params.permit(type: [:option_id, :value])
  end
end
