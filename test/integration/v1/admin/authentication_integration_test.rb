require 'test_helper'

module V1
  module Admin
    class AuthenticationIntegrationTest < ActionDispatch::IntegrationTest
      def setup
        # debugger
        # JsonWebToken.encode(user_id: users('admin').id)
        # @header = admin_header
      end

      test 'returns 200 if a user exists for given email' do
        skip("TODO")

        # JsonWebToken.encode(user_id: users('admin').id)
        post '/v1/admin/auth/verify-email', headers: @header, params: { email: 'admin@interflux.com'}

        assert_response 200
      end

      test 'returns 404 if no user exists for given email' do
        skip("TODO")

        # JsonWebToken.encode(user_id: users('admin').id)
        post '/v1/admin/auth/verify-email', headers: @header, params: { email: 'robot@evil.corp'}

        assert_response 404
      end
    end
  end
end
