module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :set_project, only: [ :show, :update, :destroy ]

      def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        projects = Project.page(page).per(per_page)

        render json: projects,
               each_serializer: Api::V1::Projects::ProjectIndexSerializer,
               meta: {
                total_pages: projects.total_pages,
                current_page: projects.current_page
              }, status: :ok
      end

      def show
        render json: @project, serializer: Api::V1::Projects::ProjectSerializer, status: :ok
      end

      def create
        project = Project.new(project_params)

        if project.save
           render json: project, serializer: Api::V1::Projects::ProjectSerializer, status: :created
        else
          render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @project.update(project_params)
          render json: @project, serializer: Api::V1::Projects::ProjectSerializer, status: :ok
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ArgumentError => e
        render json: { errors: [ e.message ] }, status: :unprocessable_entity
      end

      def destroy
        if @project.destroy
          render json: { message: "Project #{@project.title} deleted successfully" }, status: :ok
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
