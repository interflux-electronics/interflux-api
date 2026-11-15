module CurrentUser
  extend ActiveSupport::Concern

  included do
    before_action :authorise_user, :authorise_ability
  end

  private

  def authorise_user
    # Mobile apps send the JWT via Authorization headers
    # Web apps send the JWT via HTTP-only cookies
    access_token = request.authorization || cookies[:access_token]
    jwt_token = access_token&.split&.last
    decoded = JWT.decode(jwt_token, Rails.application.secret_key_base)[0]
    @user = User.find(decoded['user_id'])
  rescue JWT::ExpiredSignature
    render json: { error: 'Token expired' }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: :unauthorized
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :unauthorized
  end

  def authorise_ability
    if respond_to?(:model_class, true) && model_class.present?
      resource = model_class.name.underscore.pluralize
      action = case request.method
               when 'GET'
                 'read'
               when 'POST'
                 'create'
               when 'PUT', 'PATCH'
                 'update'
               when 'DELETE'
                 'delete'
               end

      @user_is_able = @user.can?("#{action}_#{resource}")
    end
  rescue StandardError => e
    render json: { error: 'Ability error', detail: e }, status: :forbidden
  end

  # Checks the abilities on the user record to see if this action is permitted.
  # Set @user_is_able to override this behaviour locally.
  def user_has_ability?(action)
    resource = model_class.name.underscore.pluralize

    @user_is_able || @user.can?("#{action}_#{resource}")
  end
end
