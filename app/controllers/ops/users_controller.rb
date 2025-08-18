class Ops::UsersController < Ops::ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.all.includes(:roles)

    # Apply filters
    if params[:name].present?
      @users = @users.where("name ILIKE ?", "%#{params[:name]}%")
    end

    if params[:email].present?
      @users = @users.where("email ILIKE ?", "%#{params[:email]}%")
    end

    if params[:role].present?
      @users = @users.joins(:roles).where(roles: { name: params[:role] }).distinct
    end
  end

  def show
    @orders = @user.orders.includes(order_items: { product_variant: :product })
                   .order(created_at: :desc)
                   .limit(10)
  end

  def edit
    @roles = Role.all
  end

  def update
    if @user.update(user_params)
      # Update roles if provided
      if params[:role_ids].present?
        @user.roles = Role.where(id: params[:role_ids])
      end
      redirect_to ops_user_path(@user), notice: "User updated successfully!"
    else
      @roles = Role.all
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to ops_users_path, notice: "User deleted successfully!"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone, :address)
  end
end
