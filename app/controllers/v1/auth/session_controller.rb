module V1
  module Auth
    class SessionController < ApplicationController
      # POST /refresh?refresh_token=123
      def refresh
        refresh_token = RefreshToken.find_by(token: refresh_params[:refresh_token])
        if refresh_token&.valid_token?
          render status: :ok, json: {
            access_token: encode_access_token(refresh_token.user)
          }
        else
          render json: { error: 'Invalid or expired refresh token' }, status: :unauthorized
        end
      end

      # POST /logout?refresh_token=123
      def destroy
        refresh_token = RefreshToken.find_by(token: params[:refresh_token])
        refresh_token.destroy

        render status: :ok
      end

      def user; end

      private

      def login_params
        params.permit(:email, :password)
      end

      def refresh_params
        params.permit(:refresh_token)
      end

      # Encode JWT access token
      def encode_access_token(user)
        payload = { user_id: user.id, exp: 1.hour.from_now.to_i }
        JWT.encode(payload, Rails.application.secret_key_base)
      end

      # Generate and store refresh token
      def generate_refresh_token(user)
        token = SecureRandom.hex(32)
        RefreshToken.create!(
          user:,
          token:,
          expires_at: 7.days.from_now
        )
        token
      end
    end
  end
end
