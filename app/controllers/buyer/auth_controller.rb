class Buyer::AuthController < Buyer::ApplicationController
  skip_before_action :authenticate_buyer, only: [ :login, :register, :create_session, :create_account ]

  def login
    # Show login form
  end

  def register
    @user = User.new
  end

  def create_session
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      session[:buyer_token] = token
      redirect_to buyer_root_path, notice: "Successfully logged in!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :login
    end
  end

  def create_account
    @user = User.new(user_params)
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      session[:buyer_token] = token
      redirect_to buyer_root_path, notice: "Account created successfully!"
    else
      render :register
    end
  end

  def logout
    session[:buyer_token] = nil
    redirect_to buyer_login_path, notice: "Successfully logged out!"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :address)
  end
end
