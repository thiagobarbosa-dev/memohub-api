class Api::V1::SectionsController < Api::V1::ApiController
  before_action :set_section, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:show, :update, :destroy]

  # GET /api/v1/users/:user_id/notebooks/:notebook_id/sections
  def index
    user_id = params[:user_id]

    if user_id != current_user.id.to_s
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    else
      @sections = current_user.notebooks.find(params[:notebook_id]).sections
      render json: @sections
    end
  end

  # GET /api/v1/users/:user_id/notebooks/:notebook_id/sections/1
  def show
    render json: @section
  end

  # POST /api/v1/users/:user_id/notebooks/:notebook_id/sections
  def create
    user_id = params[:user_id]

    if user_id != current_user.id.to_s
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    else
      @section = current_user.notebooks.find(params[:notebook_id]).sections.build(section_params)

      if @section.save
        render json: @section, status: :created
      else
        render json: @section.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /api/v1/users/:user_id/notebooks/:notebook_id/sections/1
  def update
    if @section.update(section_params)
      render json: @section
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/notebooks/:notebook_id/sections/1
  def destroy
    @section.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = current_user.notebooks.find(params[:notebook_id]).sections.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def section_params
      params.require(:section).permit(:title)
    end

    def authorize_user
      user_id = params[:user_id]
      return if @section.notebook.user == current_user && user_id == current_user.id.to_s

      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
end
