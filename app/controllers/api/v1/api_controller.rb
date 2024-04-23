class Api::V1::ApiController < ApplicationController
  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers['Authorization'].split(' ').last if request.headers['Authorization']
    render json: { error: 'Unauthorized' }, status: :unauthorized unless token_valid?(token)
  rescue JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def token_valid?(token)
    return false unless token
    decoded_token = JwtService.decode(token)
    user_id = decoded_token['user_id']
    @current_user = User.find(user_id)
    true
  rescue ActiveRecord::RecordNotFound
    false
  end

  def current_user
    @current_user
  end
end
