class Api::V1::ProductOptionValuesController < ApplicationController
  before_action -> { authorize!("manage_system") }, except: [:index]
  before_action -> { authorize!("manage_store") }, only: [:index]
  before_action :set_product_option, :set_option_values

  def index
    render json: {data: {option_values: @option_value}, message: ""}, status: :ok
  end

  def create
    @product_option.product_option_values.create(value: params[:value])
    if @product_option.save
      render json: {data: {option_value: @product_option.product_option_values}, message: "Option value created successfully"}, status: :created
    else
      render json: {errors: @product_option.errors}, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy

  end


  private
  def set_product_option
    @product_option = ProductOption.find_by(id: params[:product_option_id])
  end

  def set_option_values
    @option_value = @product_option.product_option_values
  end
end
