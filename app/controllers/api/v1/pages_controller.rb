class Api::V1::PagesController < Api::V1::ApiController
  before_action :authorize_user, only: %i[show update destroy]
  before_action :set_page, only: %i[show update destroy]

  # GET /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages
  def index
    if authorized_user?
      @pages = current_user.notebooks.find(params[:notebook_id]).sections.find(params[:section_id]).pages
      render json: @pages
    else
      render_unauthorized
    end
  end

  # GET /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages/:id
  def show
    render json: @page
  end

  # POST /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages
  def create
    if authorized_user?
      @page = current_user.notebooks.find(params[:notebook_id]).sections.find(params[:section_id]).pages.build(page_params)

      if @page.save
        render json: @page, status: :created
      else
        render json: @page.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  # PATCH/PUT /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages/:id
  def update
    if @page.update(page_params)
      render json: @page
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages/:id
  def destroy
    @page.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
      render_unauthorized unless @page.section.notebook.user == current_user
    end

    # Only allow a list of trusted parameters through.
    def page_params
      params.require(:page).permit(:title, :content)
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
