module V1
  module Auth
    class OneTimePasswordController < ApplicationController
      # POST /api/v1/auth/otp/create
      # JSON { user: { email: "foo@bar.com" } }
      def create
        return head 401 if email.nil?

        user = User.find_by(email:)

        return head 404 if user.nil?

        otp = OneTimePassword.create!(user:)

        begin
          message = InterfluxMailer.otp(otp).deliver_now
        rescue Postmark::Error
          otp.destroy
          return head 502
        end

        if message.delivery_method.is_a?(Mail::Postmark) && !message.delivered?
          otp.destroy
          return head 502
        end

        render status: 200, json: { otp: { id: otp.id } }
      end

      # POST /api/v1/auth/otp/check
      # JSON { otp: { id: "UUID", code: "654321" } }
      def check
        return head 401 if id.nil?
        return head 401 if code.nil?

        otp = OneTimePassword.find(id)

        otp.update!(attempts: otp.attempts + 1)

        return head 401 if otp.nil?
        return head 401 if otp.created_at < 5.minutes.ago
        return head 401 if otp.attempts >= 3
        return head 401 if otp.suspended
        return head 401 if otp.code.nil?
        return head 401 if otp.code != code

        user = otp.user
        at = encode_access_token(user)
        rt = generate_refresh_token(user)

        render status: 200, json: {
          access_token: at,
          refresh_token: rt
        }
      end

      private

      def user_params
        params.require(:user).permit(:email)
      end

      def otp_params
        params.require(:otp).permit(:id, :code)
      end

      def email
        user_params[:email]
      end

      def code
        otp_params[:code]
      end

      def id
        otp_params[:id]
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
