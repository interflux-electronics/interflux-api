# This service is responsible for encoding and decoding JSON web tokens (JWT)
#
# Usage:
# data = { user_id: @user.id }
# encoded_data = JsonWebToken.new(data).encode
# decoded_data = JsonWebToken.new(encoded_data).decode
#
# Inspired from:
# https://medium.com/binar-academy/rails-api-jwt-authentication-a04503ea3248
#
class JsonWebToken
  def initialize(data, expiry = 90.days.from_now)
    @data = data
    @expiry = expiry
  end

  def encode
    @data[:expiry] = @expiry.to_i
    JWT.encode(@data, jwt_secret)
  end

  def decode
    decoded = JWT.decode(@data, jwt_secret)[0]
    HashWithIndifferentAccess.new decoded
  rescue JWT::DecodeError => _e
    nil
  end

  private

  def jwt_secret
    Rails.application.credentials.jwt_secret
  end
end
