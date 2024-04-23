class Api::V1::PagesController < Api::V1::ApiController
  before_action :set_page, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:show, :update, :destroy]

  # GET /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages
  def index
    user_id = params[:user_id]

    if user_id != current_user.id.to_s
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    else
      @pages = current_user.notebooks.find(params[:notebook_id]).sections.find(params[:section_id]).pages
      render json: @pages
    end
  end

  # GET /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages/1
  def show
    render json: @page
  end

  # POST /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages
  def create
    user_id = params[:user_id]

    if user_id != current_user.id.to_s
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    else
      @page = current_user.notebooks.find(params[:notebook_id]).sections.find(params[:section_id]).pages.build(page_params)

      if @page.save
        render json: @page, status: :created
      else
        render json: @page.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages/1
  def update
    if @page.update(page_params)
      render json: @page
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages/1
  def destroy
    @page.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = current_user.notebooks.find(params[:notebook_id]).sections.find(params[:section_id]).pages.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def page_params
      params.require(:page).permit(:title, :content)
    end

    def authorize_user
      user_id = params[:user_id]
      return if @page.section.notebook.user == current_user && user_id == current_user.id.to_s

      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
end
