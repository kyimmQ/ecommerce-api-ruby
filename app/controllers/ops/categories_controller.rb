class Ops::CategoriesController < Ops::ApplicationController
  before_action :set_category, only: [ :show, :edit, :update, :destroy ]

  def index
    @categories = Category.all.includes(:parent, :children)
  end

  def show
    @products = @category.products.includes(:owner)
    @subcategories = @category.children
  end

  def new
    @category = Category.new
    @parent_categories = Category.all
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to ops_categories_path, notice: "Category created successfully!"
    else
      @parent_categories = Category.all
      render :new
    end
  end

  def edit
    @parent_categories = Category.where.not(id: @category.id)
  end

  def update
    if @category.update(category_params)
      redirect_to ops_categories_path, notice: "Category updated successfully!"
    else
      @parent_categories = Category.where.not(id: @category.id)
      render :edit
    end
  end

  def destroy
    if @category.children.any?
      redirect_to ops_categories_path, alert: "Cannot delete category with subcategories"
    elsif @category.products.any?
      redirect_to ops_categories_path, alert: "Cannot delete category with products"
    else
      @category.destroy
      redirect_to ops_categories_path, notice: "Category deleted successfully!"
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :parent_id)
  end
end
