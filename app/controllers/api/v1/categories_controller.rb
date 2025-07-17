class Api::V1::CategoriesController < ApplicationController
  before_action -> { authorize!("manage_system") }, except: index

  def index
    render json: Category.recursive_tree
  end

  def create
    category = Category.find_by(name: params[:name])
    if category
      render json: { message: "Category already exists" }, status: :not_acceptable
    end

    category = Category.new(category_params)
    if category.save
      render json: { message: "Category saved" }, status: :created
    else
      render json: { message: "Unable to create category", errors: category.errors.full_messages }, status: :not_acceptable
    end
  end

  def update
    category = Category.find_by(id: params[:id])
    unless category
      render json: { message: "Category not exists" }, status: :not_acceptable
    end
    if category.update(category_params)
      render json: { message: "Category updated" }, status: :ok
    else
      render json: { message: "Unable to update category", errors: category.errors.full_messages }, status: :not_acceptable
    end
  end

  def destroy
    category = Category.find_by(id: params[:id])
    unless category
      render json: { message: "Category not exists" }, status: :not_acceptable
    end

    if category.destroy
      render json: { message: "Category deleted" }, status: :ok
    else
      render json: { message: "Unable to delete category", errors: category.errors.full_messages }, status: :not_acceptable
    end
  end

  private
  def category_params
    params.permit(:name, :description, :parent_id)
  end
end
