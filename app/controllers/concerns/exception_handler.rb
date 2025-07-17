module ExceptionHandler
  extend ActiveSupport::Concern

  # Not found errors
  class RouteNotFound < StandardError; end

  global_errors = [ ExceptionHandler::RouteNotFound ]

  private def not_found_response(error)
    render json: { errors: [ error.message ] }, status: :not_found_response
  end


  # Internal errors
  class UnprocessableEntity < StandardError; end

  internal_errors = [ ExceptionHandler::UnprocessableEntity ]

  private def internal_error_response(error)
    render json: { errors: [ error.message ] }, status: :internal_server_error
  end


  # Authenticate errors
  class ExpiredToken < StandardError; end
  class InvalidToken < StandardError; end
  class MissingToken < StandardError; end
  class EmailExists < StandardError; end

  authenticate_errors = [ ExceptionHandler::ExpiredToken,
                         ExceptionHandler::InvalidToken,
                         ExceptionHandler::MissingToken,
                         ExceptionHandler::EmailExists ]

  private def unauthorized_response(error)
    render json: { errors: [ error.message ] }, status: :unauthorized
  end


  # Authorization errors


  def handle_argument_error(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  included do
    global_errors.each { |error| rescue_from error, with: :internal_error_response }
    internal_errors.each { |error| rescue_from error, with: :internal_error_response }
    authenticate_errors.each { |error| rescue_from error, with: :unauthorized_response }

    rescue_from ActionController::ParameterMissing, with: :handle_argument_error
  end
end
