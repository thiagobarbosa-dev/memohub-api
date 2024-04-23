class Api::V1::SectionsController < Api::V1::ApiController
  before_action :authorize_user, only: [:show, :update, :destroy]
  before_action :set_section, only: [:show, :update, :destroy]

  # GET /api/v1/users/:user_id/notebooks/:notebook_id/sections
  def index
    if authorized_user?
      @sections = current_user.notebooks.find(params[:notebook_id]).sections
      render json: @sections
    else
      render_unauthorized
    end
  end

  # GET /api/v1/users/:user_id/notebooks/:notebook_id/sections/:id
  def show
    render json: @section
  end

  # POST /api/v1/users/:user_id/notebooks/:notebook_id/sections
  def create
    if authorized_user?
      @section = current_user.notebooks.find(params[:notebook_id]).sections.build(section_params)

      if @section.save
        render json: @section, status: :created
      else
        render json: @section.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  # PATCH/PUT /api/v1/users/:user_id/notebooks/:notebook_id/sections/:id
  def update
    if @section.update(section_params)
      render json: @section
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/notebooks/:notebook_id/sections/:id
  def destroy
    @section.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
      render_unauthorized unless @section.notebook.user == current_user
    end

    # Only allow a list of trusted parameters through.
    def section_params
      params.require(:section).permit(:title)
    end

    def authorize_user
      render_unauthorized unless authorized_user?
    end
  
    def authorized_user?
      user_id = params[:user_id].to_i if params[:user_id].present?
      user_id == current_user.id
    end

    def render_unauthorized
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
end
