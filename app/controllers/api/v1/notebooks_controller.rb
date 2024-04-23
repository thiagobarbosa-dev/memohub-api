class Api::V1::NotebooksController < Api::V1::ApiController
  before_action :authorize_user, only: %i[show update destroy]
  before_action :set_notebook, only: %i[show update destroy]

  # GET /api/v1/users/:user_id/notebooks
  def index
    if authorized_user?
      @notebooks = current_user.notebooks
      render json: @notebooks
    else
      render_unauthorized
    end
  end

  # GET /api/v1/users/:user_id/notebooks/:id
  def show
    render json: @notebook
  end

  # POST /api/v1/users/:user_id/notebooks
  def create
    if authorized_user?
      @notebook = Notebook.new(notebook_params)

      if @notebook.save
        render json: @notebook, status: :created
      else
        render json: @notebook.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  # PATCH/PUT /api/v1/users/:user_id/notebooks/:id
  def update
    if @notebook.update(notebook_params)
      render json: @notebook
    else
      render json: @notebook.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/notebooks/:id
  def destroy
    @notebook.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notebook
      @notebook = Notebook.find(params[:id])
      render_unauthorized unless @notebook.user == current_user
    end

    # Only allow a list of trusted parameters through.
    def notebook_params
      params.require(:notebook).permit(:title, :user_id)
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
