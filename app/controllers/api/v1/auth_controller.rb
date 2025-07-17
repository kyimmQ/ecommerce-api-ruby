module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authorize_request

      def login
        # ✅ validate required login params first
        login_params

        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { user: { id: user.id, name: user.name, email: user.email, phone: user.phone, address: user.address }, token: token }, status: :ok
        else
          render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
      end

      def register
        # ✅ validate required register params first
        user_params

        if User.exists?(email: params[:email])
          raise ExceptionHandler::EmailExists, "Email already exists"
        end

        user = User.new(user_params)
        if user.save
          render json: { message: "User created." }, status: :created
        else
          raise ExceptionHandler::UnprocessableEntity, "Fail to register user"
        end
      end

      private

      def user_params
        require_keys!(%w[name email password phone address])
        params.permit(:name, :email, :password, :phone, :address)
      end

      def login_params
        require_keys!(%w[email password])
        params.permit(:email, :password)
      end

      def require_keys!(keys)
        missing = keys.select { |k| params[k].blank? }
        raise ActionController::ParameterMissing, "Missing required parameters: #{missing.join(', ')}" if missing.any?
      end
    end
  end
end
