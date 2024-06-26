class Api::V1::UsersController < Api::V1::ApiController
  before_action :set_user, only: %i[show update destroy]

  # GET /api/v1/users
  def index
    @users = User.all
    render json: @users
  end

  # GET /api/v1/users/1
  def show
    render json: @user
  end

  # POST /api/v1/users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    begin
      @user = User.find(params[:id])
    rescue => e
      if e.class == ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      else
        render json: { error: "Internal server error: #{e.message}" }, status: :internal_server_error
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :login, :email, :password, :password_confirmation)
  end
end
