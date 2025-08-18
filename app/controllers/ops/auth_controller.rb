class Ops::AuthController < Ops::ApplicationController
  skip_before_action :authenticate_admin, only: [ :login, :create_session ]

  def login
    # Show admin login form
  end

  def create_session
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      # Check if user has admin permissions
      if user.permissions.pluck(:name).include?("manage_system") ||
         user.permissions.pluck(:name).include?("manage_store")
        token = JsonWebToken.encode(user_id: user.id)
        session[:admin_token] = token
        redirect_to ops_dashboard_path, notice: "Successfully logged in!"
      else
        flash.now[:alert] = "Access denied. Admin privileges required."
        render :login
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :login
    end
  end

  def logout
    session[:admin_token] = nil
    redirect_to ops_login_path, notice: "Successfully logged out!"
  end
end
