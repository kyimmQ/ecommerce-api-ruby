class ApplicationController < ActionController::Base
  include ExceptionHandler

  # Enable CSRF protection for web requests, skip for API requests
  protect_from_forgery with: :exception, unless: :api_request?

  before_action :authorize_request, if: :api_request?

  def authorize_request
    header = request.headers["Authorization"]
    raise ExceptionHandler::MissingToken, "Authorization token not provided" if header.blank?
    token = header.split.last if header
    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id])
  end

  def current_user
    @current_user
  end

  def authorize!(permission_name)
    unless current_user&.can?(permission_name)
      if api_request?
        render json: { error: "Unauthorize for this action" }, status: :unauthorized
      else
        redirect_to root_path, alert: "Unauthorized for this action"
      end
    end
  end

  private

  def api_request?
    request.path.start_with?("/api/")
  end
end
