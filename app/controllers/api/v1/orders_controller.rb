class Api::V1::OrdersController < ApplicationController
  # before_action :set_order, only: %i[show update]

  def index
    orders = @current_user.orders.includes(order_items: { product_variant: :product })
    render json: { data: orders.as_json(include: { order_items: { include: { product_variant: { include: :product } } } }), message: "" }, status: :ok
  end

  # GET /api/v1/orders/:id
  def show
    render json: { data: @order.as_json(include: { order_items: { include: { product_variant: { include: :product } } } }), message: "" }, status: :ok
  end
  def create
    cart_items = @current_user.shopping_cart.cart_items.includes(:product_variant)
    cart_items = cart_items.where(id: order_params[:cart_items])
    puts "Cart Items: #{cart_items.inspect}"
    if cart_items.empty?
      render json: { errors: "No cart items selected." }, status: :not_found
    end

    order = @current_user.orders.new(status: :pending, total_price: 0)

    # Use a transaction to ensure that all database operations succeed or none do
    ActiveRecord::Base.transaction do
      order.save!
      total_price = 0
      # Calculate total price and create order items
      cart_items.each do |cart_item|
        price = cart_item.product_variant.price
        quantity = cart_item.quantity
        total_price += price * quantity
        order.order_items.create(product_variant_id: cart_item.product_variant_id, price: price, quantity: quantity)
      end

      order.update_column(:total_price, total_price)
      # Remove the items from the cart now that the order is placed
      cart_items.destroy_all
    end
    render json: { data: order.as_json(include: { order_items: { only: [:id, :product_variant_id, :price, :quantity] } }), message: "Order created successfully." }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def set_order
    @order = @current_user.orders.find(params[:id])
  end
  private

  def order_params
    params.require(:order).permit(cart_items: [])
  end
end
