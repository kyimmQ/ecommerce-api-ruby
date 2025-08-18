class Ops::OrdersController < Ops::ApplicationController
  before_action :set_order, only: [ :show, :update, :destroy ]

  def index
    @orders = Order.all.includes(:user, order_items: { product_variant: :product })
                   .order(created_at: :desc)

    # Apply filters
    if params[:status].present?
      @orders = @orders.where(status: params[:status])
    end

    if params[:user_email].present?
      @orders = @orders.joins(:user).where("users.email ILIKE ?", "%#{params[:user_email]}%")
    end

    if params[:date_from].present?
      @orders = @orders.where("created_at >= ?", Date.parse(params[:date_from]))
    end

    if params[:date_to].present?
      @orders = @orders.where("created_at <= ?", Date.parse(params[:date_to]).end_of_day)
    end
  end

  def show
    @order_items = @order.order_items.includes(product_variant: :product)
  end

  def update
    if @order.update(order_params)
      redirect_to ops_order_path(@order), notice: "Order updated successfully!"
    else
      redirect_to ops_order_path(@order), alert: "Failed to update order"
    end
  end

  def destroy
    @order.destroy
    redirect_to ops_orders_path, notice: "Order deleted successfully!"
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
