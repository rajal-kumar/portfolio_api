module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :set_project, only: [:show, :update, :destroy]

      def index
        projects = Project.all
        render json: projects, status: :ok
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

