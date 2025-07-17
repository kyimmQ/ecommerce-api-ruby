class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :authorize_request

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
      render json: {error: "Unauthorize for this action"}, status: :unauthorized
    end
  end
end
