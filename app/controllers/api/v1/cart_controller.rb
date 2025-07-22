class Api::V1::CartController < ApplicationController
  def index
    cart_items = current_user.shopping_cart.cart_items
    render json: { data: {items: cart_items}, message: "" }, status: :ok
  end
end
