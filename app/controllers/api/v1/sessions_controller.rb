class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(login: params[:login])
    if user && user.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: { token: token }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
