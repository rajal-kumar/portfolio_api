class Api::V1::ProjectsController < Api::V1::BaseController
  def index
    @projects = Project.all
    render json: @projects, status: :ok
  end

  def show
    @project = Project.find(params[:id])
    render json: @project, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Project not found' }, status: :not_found
  end

  private

  def project_params
   params.expect(project: [:title, :description, :status, :technology_stack, :repository_url, :live_url, :notes])
  end
end
