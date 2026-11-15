module V1
  module Auth
    class UserController < ApplicationController
      include CurrentUser

      # Returns the auth user data (if the request passes authentication)
      def show
        render status: 200, json: {
          user: @user.as_json(
            only: %i[id email abilities],
            include: {
              person: {
                only: %i[id first_name last_name]
              }
            }
          )
        }
      end
    end
  end
end
