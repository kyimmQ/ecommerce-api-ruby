class Ops::ApplicationController < ApplicationController
  layout "ops"

  before_action :authenticate_admin
  skip_before_action :authorize_request, if: :skip_api_auth?

  private

  def authenticate_admin
    token = request.headers["Authorization"]&.split(" ")&.last || session[:admin_token]

    if token
      begin
        decoded = JsonWebToken.decode(token)
        @current_admin = User.find(decoded[:user_id])

        # Check if user has admin permissions
        unless @current_admin.permissions.pluck(:name).include?("manage_system") ||
               @current_admin.permissions.pluck(:name).include?("manage_store")
          redirect_to ops_login_path, alert: "Access denied. Admin privileges required."
          return
        end

        session[:admin_token] = token
      rescue JWT::DecodeError
        redirect_to ops_login_path, alert: "Please log in to continue"
      end
    else
      redirect_to ops_login_path, alert: "Please log in to continue"
    end
  end

  def current_admin
    @current_admin
  end

  def skip_api_auth?
    true # Skip API authentication for web interface
  end

  helper_method :current_admin
end
