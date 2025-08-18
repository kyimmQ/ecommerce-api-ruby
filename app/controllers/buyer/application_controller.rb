class Buyer::ApplicationController < ApplicationController
  layout "buyer"

  before_action :authenticate_buyer
  skip_before_action :authorize_request, if: :skip_api_auth?

  private

  def authenticate_buyer
    token = request.headers["Authorization"]&.split(" ")&.last || session[:buyer_token]

    if token
      begin
        decoded = JsonWebToken.decode(token)
        @current_buyer = User.find(decoded[:user_id])
        session[:buyer_token] = token
      rescue ExceptionHandler::ExpiredToken, ExceptionHandler::InvalidToken, JWT::DecodeError, ActiveRecord::RecordNotFound => e
        session[:buyer_token] = nil # Clear invalid token
        redirect_to buyer_login_path, alert: "Your session has expired. Please log in again."
      end
    else
      redirect_to buyer_login_path, alert: "Please log in to continue"
    end
  end

  def authenticate_buyer_optional
    token = request.headers["Authorization"]&.split(" ")&.last || session[:buyer_token]

    if token
      begin
        decoded = JsonWebToken.decode(token)
        @current_buyer = User.find(decoded[:user_id])
        session[:buyer_token] = token
      rescue ExceptionHandler::ExpiredToken, ExceptionHandler::InvalidToken, JWT::DecodeError, ActiveRecord::RecordNotFound => e
        session[:buyer_token] = nil # Clear invalid token
        @current_buyer = nil
      end
    else
      @current_buyer = nil
    end
  end

  def current_buyer
    @current_buyer
  end

  def skip_api_auth?
    true # Skip API authentication for web interface
  end

  helper_method :current_buyer
end
