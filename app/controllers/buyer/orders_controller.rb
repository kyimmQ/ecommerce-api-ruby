class Buyer::OrdersController < Buyer::ApplicationController
  def index
    @orders = current_buyer.orders.includes(order_items: { product_variant: :product }).order(created_at: :desc)
  end

  def show
    @order = current_buyer.orders.find(params[:id])
    @order_items = @order.order_items.includes(product_variant: :product)
  end

  def create
    @cart = current_buyer.shopping_cart
    @cart_items = @cart.cart_items.includes(:product_variant)

    if @cart_items.empty?
      redirect_to buyer_cart_path, alert: "Your cart is empty"
      return
    end

    @order = current_buyer.orders.new(status: :pending, total_price: 0)

    ActiveRecord::Base.transaction do
      @order.save!
      total_price = 0

      @cart_items.each do |cart_item|
        price = cart_item.product_variant.price
        quantity = cart_item.quantity
        total_price += price * quantity
        @order.order_items.create!(
          product_variant_id: cart_item.product_variant_id,
          price: price,
          quantity: quantity
        )
      end

      @order.update_column(:total_price, total_price)
      @cart_items.destroy_all
    end

    redirect_to buyer_order_path(@order), notice: "Order placed successfully!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to buyer_cart_path, alert: "Failed to place order. Please try again."
  end

  def checkout
    @cart = current_buyer.shopping_cart
    @cart_items = @cart.cart_items.includes(product_variant: :product)
    @total = @cart_items.sum { |item| item.quantity * item.product_variant.price }

    if @cart_items.empty?
      redirect_to buyer_cart_path, alert: "Your cart is empty"
    end
  end
end
