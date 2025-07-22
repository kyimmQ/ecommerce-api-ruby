class Api::V1::CartItemsController < ApplicationController
  before_action :set_shopping_cart

  def create
    cart_item = @shopping_cart.cart_items.create(cart_item_params)
    if cart_item.save
      render json: { data: { item: cart_item }, message: "Item added to cart successfully." }, status: :created
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    cart_item = CartItem.find(params[:id])
    if cart_item
      current_quantity = cart_item.quantity.to_i
      new_quantity = cart_item_params[:quantity].to_i + current_quantity
      if new_quantity <= 0
        cart_item.destroy
        return render json: { message: "Cart item removed successfully." }, status: :ok
      end
      if cart_item.update(quantity: new_quantity)
        render json: { data: { item: cart_item }, message: "Cart item updated successfully." }, status: :ok
      else
        render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Cart item not found." }, status: :not_found
    end
  end

  private
  def set_shopping_cart
    @shopping_cart = current_user.shopping_cart
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_variant_id, :quantity)
  end
end
