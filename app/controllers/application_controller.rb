class ApplicationController < ActionController::API
  before_action :authenticate

  rescue_from JWT::VerificationError, with: :invalid_token
  rescue_from JWT::DecodeError, with: :decode_error

  def current_user
    @current_user ||= begin
      if decoded_token
        user_id = decoded_token[0]['user_id']
        User.find_by(id: user_id)
      end
    end
  end

  private

  def authenticate
    authorization_header = request.headers['Authorization']
    token = authorization_header&.split(" ")&.last 
    @decoded_token = JsonWebToken.decode(token)
    @current_user = User.find(decoded_token[:user_id])
  end

  def decoded_token
    @decoded_token
  end

  def invalid_token
    render json: { invalid_token: 'invalid token' }
  end
 
  def decode_error
    render json: { decode_error: 'decode error ba', errors: error.full_messages }
  end

end
