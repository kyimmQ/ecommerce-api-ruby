class Buyer::CartController < Buyer::ApplicationController
  def index
    @cart = current_buyer.shopping_cart
    @cart_items = @cart.cart_items.includes(product_variant: :product)
    @total = @cart_items.sum { |item| item.quantity * item.product_variant.price }
  end

  def add_item
    @cart = current_buyer.shopping_cart
    @cart_item = @cart.cart_items.find_by(product_variant_id: params[:product_variant_id])

    if @cart_item
      @cart_item.quantity += params[:quantity].to_i
      @cart_item.save
    else
      @cart_item = @cart.cart_items.create(
        product_variant_id: params[:product_variant_id],
        quantity: params[:quantity].to_i
      )
    end

    if @cart_item.persisted?
      redirect_to buyer_cart_path, notice: "Item added to cart!"
    else
      redirect_back(fallback_location: buyer_products_path, alert: "Failed to add item to cart")
    end
  end

  def update_item
    @cart_item = current_buyer.shopping_cart.cart_items.find(params[:id])

    if params[:quantity].to_i <= 0
      @cart_item.destroy
      redirect_to buyer_cart_path, notice: "Item removed from cart"
    else
      @cart_item.update(quantity: params[:quantity])
      redirect_to buyer_cart_path, notice: "Cart updated"
    end
  end

  def remove_item
    @cart_item = current_buyer.shopping_cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to buyer_cart_path, notice: "Item removed from cart"
  end
end
