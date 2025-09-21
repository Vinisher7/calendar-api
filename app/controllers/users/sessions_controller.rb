# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # Disable Devise session creation
  before_action :skip_session!

  private

  def skip_session!
    request.session_options[:skip] = true
  end

  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200,
        message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
      jwt_payload = JWT.decode(token, Rails.application.credentials.secret_key_base).first
      current_user = User.find(jwt_payload['sub'])
    end

    if current_user
      render json: { status: 200, message: 'Logged out successfully.' }, status: :ok
    else
      render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
    end
  end
end
