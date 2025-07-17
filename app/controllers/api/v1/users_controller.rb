class Api::V1::UsersController < ApplicationController
  before_action -> { authorize!("manage_system") }, only: %i[index show]
  before_action :set_user, only: %i[show destroy]

  # GET /api/v1/users/me
  def me
    render json: { data: current_user.slice(:id, :name, :email, :phone, :address), message: "" }, status: :ok
  end
  # PUT /api/v1/users/me
  def update_me
    puts user_params
    if current_user.update(user_params)
      render json: { data: nil, message: "Profile updated successfully." }, status: :ok
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users?name=&email=&phone=&ro
  def index
    users = User.includes(:roles)

    # Optional filters
    users = users.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    users = users.where("email ILIKE ?", "%#{params[:email]}%") if params[:email].present?
    users = users.where("phone ILIKE ?", "%#{params[:phone]}%") if params[:phone].present?
    if params[:role].present?
      if params[:role].is_a?(String)
        # String input like "admin,owner" → require all roles
        role_names = params[:role].split(",").map(&:strip)

        users = users
                  .joins(:roles)
                  .where(roles: { name: role_names })
                  .group("users.id")
                  .having("COUNT(DISTINCT roles.id) = ?", role_names.length)

      elsif params[:role].is_a?(Array)
        # Array input like ["admin", "owner"] → any matching role
        users = users
                  .joins(:roles)
                  .where(roles: { name: params[:role] })
                  .distinct
      end
    end

    render json: { data: users.as_json(only: [:id, :name, :email, :phone], include: { roles: { only: [:name] } }), message: "" }
  end

  # GET /api/v1/users/:id
  def show
    render json: { data: @user.slice(:id, :name, :email, :phone, :address).merge(
      roles: @user.roles.pluck(:name),
      permissions: @user.permissions.pluck(:name)
    ), message: "" }, status: :ok
  end

  # DELETE /api/v1/users/:id
  def destroy
    @user.destroy
    render json: { data: nil, message: "User deleted successfully." }, status: :ok
  end

  def user_params
    params.permit(:name, :email, :phone, :address)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: "User not found" }, status: :not_found unless @user
  end

end
