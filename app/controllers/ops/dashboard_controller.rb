class Ops::DashboardController < Ops::ApplicationController
  def index
    @total_users = User.count
    @total_products = Product.count
    @total_orders = Order.count
    @total_categories = Category.count

    @recent_orders = Order.includes(:user, order_items: { product_variant: :product })
                          .order(created_at: :desc)
                          .limit(10)

    @top_products = Product.joins(product_variants: { order_items: :order })
                           .group("products.id")
                           .order("COUNT(order_items.id) DESC")
                           .limit(5)

    @monthly_revenue = Order.where(created_at: 1.month.ago..Time.current)
                           .sum(:total_price)

    @pending_orders = Order.where(status: :pending).count
  end
end
