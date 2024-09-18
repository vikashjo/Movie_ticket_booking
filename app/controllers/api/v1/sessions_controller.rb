module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate

      def login
        user = User.find_by(email: params[:email])
        authenticate_user = user&.authenticate(params[:password])
        if authenticate_user
          token = JsonWebToken.encode(user_id: user.id)
          expires_at = JsonWebToken.decode(token)[:exp]

          render json: { token:, expires_at: expires_at, data: user }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end
    end
  end
end
