class Api::V1::ProductOptionsController < ApplicationController
  before_action -> { authorize!("manage_system") }, except: [ :index ]
  before_action -> { authorize!("manage_store") }, only: [ :index ]
  before_action :set_category, except: [ :delete_option ]
  def index
    all_options = @category.all_product_options
    render json: { data: { category: @category.name, options: all_options }, message: "" }, status: :ok
  end

  def create
    all_options = @category.all_product_options
    all_options.each do |option|
      if option.name == params[:name]
        render json: { message: "Product option already exists" }, status: :unprocessable_entity
      end
    end
    new_option = ProductOption.create(name: params[:name])
    unless new_option.save
      render json: { message: "Cannot create new option" }, status: :unprocessable_entity
    end

    @category.product_options << new_option
    render json: { message: "Product option created for #{@category.name}", data: { option: new_option } }, status: :created
  end

  def destroy
    begin
      option = @category.product_options.find(params[:id])
      @category.product_options.destroy(option) if option
      render json: { message: "Product option deleted" }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { message: "Product option not found" }, status: :not_found
    rescue StandardError => e
      render json: { message: "Error deleting product option", error: e.message }, status: :unprocessable_entity
    end
  end

  def delete_option
    option = ProductOption.find(params[:id])
    if option
      if option.destroy
        render json: { message: "Product option deleted" }, status: :ok
      else
        render json: { message: "Unable to delete product option", errors: option.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "Product option not found" }, status: :not_found
    end
  end



  private
  def set_category
    @category = Category.find_by(id: params[:category_id])
    unless @category
      render json: { message: "Category not found" }, status: :not_found
    end
  end
end
