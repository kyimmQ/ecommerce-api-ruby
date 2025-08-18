class Ops::ProductsController < Ops::ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.all.includes(:category, :owner)

    # Apply filters
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:search].present?
      @products = @products.where("name ILIKE ?", "%#{params[:search]}%")
    end

    @categories = Category.all
  end

  def show
    @variants = @product.all_variants
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    @product.owner = current_admin

    if @product.save
      redirect_to ops_product_path(@product), notice: "Product created successfully!"
    else
      @categories = Category.all
      render :new
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @product.update(product_params)
      redirect_to ops_product_path(@product), notice: "Product updated successfully!"
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to ops_products_path, notice: "Product deleted successfully!"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :category_id, :image_url)
  end
end
