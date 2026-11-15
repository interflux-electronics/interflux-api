# Inspired from:
# https://medium.com/binar-academy/rails-api-jwt-authentication-a04503ea3248
#
module V1
  class AdminController < ApplicationController
    include CurrentUser
  end
end
