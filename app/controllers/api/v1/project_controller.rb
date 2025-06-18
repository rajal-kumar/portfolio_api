class Api::V1::ProjectController < Api::V1::BaseController
  def index
    @projects = Project.all
    render json: @projects, status: :ok
  end
end
