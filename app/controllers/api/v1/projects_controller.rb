module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :set_project, only: [ :show, :update, :destroy ]

      def index
        projects = Project.all.page(params[:page]).per(params[:per_page] || 10)

        render json: {
          projects: projects.as_json,
          meta: {
            total_pages: projects.total_pages,
            current_page: projects.current_page,
            next_page: projects.next_page,
            prev_page: projects.prev_page,
            total_count: projects.total_count
          }
        }, status: :ok
      end

      def show
        render json: @project, status: :ok
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
        if @project.update(project_params)
          render json: @project, status: :ok
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ArgumentError => e
        render json: { errors: [e.message] }, status: :unprocessable_entity
      end

      def destroy
        if @project.destroy
          render json: { message: "Project deleted successfully" }, status: :ok
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_project
       @project = Project.find(params[:id])

      rescue ActiveRecord::RecordNotFound
        render json: { error: "Project not found" }, status: :not_found
      end

      def project_params
        params.require(:project).permit(:title, :description, :status, :technology_stack, :repository_url, :live_url, :notes)
      end
    end
  end
end
