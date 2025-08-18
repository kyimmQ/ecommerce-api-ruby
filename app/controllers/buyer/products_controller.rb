class Buyer::ProductsController < Buyer::ApplicationController
  skip_before_action :authenticate_buyer, only: [ :index, :show, :by_category ]
  before_action :authenticate_buyer_optional, only: [ :index, :show, :by_category ]

  def index
    @products = Product.all.includes(:category)
    @categories = Category.all

    # Apply filters
    if params[:category_id].present?
      category = Category.find_by(id: params[:category_id])
      if category
        sub_category_ids = category.all_descendant_ids
        @products = @products.where(category_id: sub_category_ids << category.id)
      end
    end

    if params[:search].present?
      @products = @products.where("name ILIKE ?", "%#{params[:search]}%")
    end

    if params[:min_price].present? && params[:max_price].present?
      # This would need to be adjusted based on your product variant pricing logic
      @products = @products.select { |product|
        price_range = product.price_range
        price_range[0] >= params[:min_price].to_f && price_range[1] <= params[:max_price].to_f
      }
    end
  end

  def show
    @product = Product.find(params[:id])
    @variants = @product.all_variants
  end

  def by_category
    @category = Category.find(params[:category_id])
    @categories = Category.all
    sub_category_ids = @category.all_descendant_ids
    @products = Product.where(category_id: sub_category_ids << @category.id).includes(:category)
    render :index
  end
end
