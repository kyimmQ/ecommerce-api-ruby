class Api::V1::ProductsController < ApplicationController
  include OwnershipValidatable

  before_action -> { authorize!("manage_store") }, except: %i[index show shop_products]
  before_action :set_product, :validate_ownership, only: %i[ destroy update ]
  before_action :set_product, only: %i[ show ]

  # GET /api/v1/products
  def index
    products = Product.all.includes(:category)

    # Optional filters
    products = products.where("name ILIKE ?", "%#{product_params[:name]}%") if product_params[:name].present?

    if product_params[:category].present?
      category = Category.find_by(id: product_params[:category])
      if category
        sub_category_ids = category.all_descendant_ids
        products = products.where(category_id: sub_category_ids << category.id)
      else
        render json: { errors: "Category not found." }, status: :not_found
      end
    end

    if variant_params[:range].present?
      price_range = variant_params[:range].split(",").map(&:strip).map(&:to_f)
      if price_range.length == 2 && price_range.all? { |p| p.is_a?(Numeric) } && price_range[0] <= price_range[1]
        products = products.select { |product| product.price_range[0] >= price_range[0] && product.price_range[1] <= price_range[1] }
      else
        render json: { errors: "Invalid price range format. Use 'min,max'." }, status: :unprocessable_entity and return
      end
    end

    render json: { data: products.map { |product| { id: product.id, name: product.name, description: product.description, price_range: product.price_range } }, message: "" }
  end

  # GET /api/v1/products/:id
  def show
    render json: { data: {
                    id: @product.id,
                    name: @product.name,
                    description: @product.description,
                    variants: @product.all_variants,
                    owner: @product.owner.slice(:id, :name, :address) }, message: ""
    }, status: :ok
  end

  # DELETE /api/v1/products/:id
  def destroy
    if @product.destroy
      render json: { data: nil, message: "Product deleted successfully." }, status: :ok
    else
      render json: { errors: @product.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: { data: { id: @product.id, name: @product.name, description: @product.description }, message: "Product updated successfully." }, status: :ok
    else
      render json: { errors: @product.errors }, status: :unprocessable_entity
    end
  end

  def create
    product = Product.new(product_params.slice(:name, :description))
    product.owner = current_user
    product.category = Category.find_by(id: product_params[:category])
    if product.save
      render json: { data: { id: product.id, name: product.name, description: product.description }, message: "Product created successfully." }, status: :created
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def shop_products
    products = Product.where(owner_id: params[:shop_id])
    render json: { data: products.map { |product| { id: product.id, name: product.name, description: product.description, price_range: product.price_range } }, message: "" }
  end

  private

  def product_params
    params.permit(:name, :category, :description)
  end

  def create_product_params
    params.require(:information).permit(:name, :category, :description)
  end

  def variant_params
    params.permit(:range)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
