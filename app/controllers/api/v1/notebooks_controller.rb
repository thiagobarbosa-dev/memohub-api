class Api::V1::NotebooksController < Api::V1::ApiController
  before_action :set_notebook, only: %i[ show update destroy ]
  before_action :authorize_user, only: %i[ show update destroy]

  # GET /api/v1/users/:user_id/notebooks
  def index
    user_id = params[:user_id]

    if user_id != current_user.id.to_s
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    else
      @notebooks = current_user.notebooks
      render json: @notebooks
    end
  end

  # GET /api/v1/users/:user_id/notebooks/1
  def show
    render json: @notebook
  end

  # POST /api/v1/users/:user_id/notebooks
  def create
    user_id = params[:user_id]

    if user_id != current_user.id.to_s
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    else
      @notebook = Notebook.new(notebook_params)

      if @notebook.save
        render json: @notebook, status: :created
      else
        render json: @notebook.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /api/v1/users/:user_id/notebooks/1
  def update
    if @notebook.update(notebook_params)
      render json: @notebook
    else
      render json: @notebook.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/notebooks/1
  def destroy
    @notebook.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notebook
      @notebook = Notebook.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notebook_params
      params.require(:notebook).permit(:title, :user_id)
    end

    def authorize_user
      user_id = params[:user_id]
      return if @notebook.user == current_user && user_id == current_user.id.to_s

      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
end
