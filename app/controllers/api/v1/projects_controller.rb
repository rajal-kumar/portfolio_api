class Api::V1::ProjectsController < Api::V1::BaseController
  def index
    @projects = Project.all
    render json: @projects, status: :ok
  end

  def show
    @project = Project.find(params[:id])
    render json: @project, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def create
    project = Project.new(project_params)

    if project.save
      render json: project, status: :created
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    project = Project.find(params[:id])

    if project.update(project_params)
      render json: project, status: :updated
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
   project = Project.find(params[:id])
   project.destroy!

    render json: { message: "Project deleted successfully" }, status: :ok
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  private

  def project_params
   params.require(:project).permit(:title, :description, :status, :technology_stack, :repository_url, :live_url, :notes)
  end
end
