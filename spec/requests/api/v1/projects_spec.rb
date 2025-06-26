require "rails_helper"

RSpec.describe "Projects API", type: :request do
  # You can use `let(:user) { create(:user) }` if auth is added later

  describe "GET /api/v1/projects" do
    context "when projects exist" do
      # setup: create projects
      let!(:project) { FactoryBot.create(:project) }

      # expectation: returns a list with 200 OK
      it "returns a list of projects with status 200 OK" do
        puts "Project count: #{Project.count}"
        get api_v1_projects_path

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json).to be_an(Array)
        expect(json.first["title"]).to eq(project.title)
      end
    end

    context "when no projects exist" do
      it "returns an empty array with 200 OK" do
        puts "Project count: #{Project.count}"
        # expectation: returns empty array with 200 OK
        get api_v1_projects_path

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json).to be_an(Array)
        expect(json).to eq([])
      end
    end
  end

  describe "GET /api/v1/projects/:id" do
    context "when the project exists" do
      # expectation: returns the project with 200 OK
      let!(:project) { FactoryBot.create(:project) }

      it "returns the project with 200 OK" do
        get api_v1_project_path(project.id)

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq(project.id)
        expect(json["title"]).to eq(project.title)
      end
    end

    context "when the project does not exist" do
      # expectation: returns 404 not found
      it "returns 404 not found" do
        get api_v1_project_path(1)

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json).to include("error" => "Project not found")
      end
    end
  end

  describe "POST /api/v1/projects" do
    context "with valid parameters" do
      # expectation: creates project and returns 201 created
      it "responds with a created status" do
        params = {
          title: "test_proj",
          description: "Simple",
          status: "in_progress",
          technology_stack: "RoR",
          repository_url: "www.shouldbeasite.com",
          live_url: "www.shouldalsobeasite.com",
          notes: ""
        }

        post api_v1_projects_path, params: { project: params }

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      # expectation: returns 422 unprocessable entity with errors
      it "responds with unprocessable_entity status" do
        params = {
          description: "",
          technology_stack: 1,
          repository_url: "www.shouldbeasite.com",
        }

        post api_v1_projects_path, params: { project: params }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    context "when the project exists and params are valid" do
      # expectation: updates project, returns 200 OK
      let!(:project) { FactoryBot.create(:project) }

      it "updates project returnd 200 OK" do
        patch api_v1_project_path(project.id), params: { project: {title: "Updated title", notes: "Added some note"}}

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq(project.id)
        expect(json["title"]).to eq("Updated title")
        expect(json["notes"]).to eq("Added some note")
      end
    end

    context "when the project exists but params are invalid" do
      # expectation: returns 422 unprocessable entity
      let!(:project) { FactoryBot.create(:project) }

      it "returns 422 unprocessable entity" do
        patch api_v1_project_path(project.id), params: { project: {title: 110011, description: 43110, status: "Not done"}}

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json).to include("errors" => ["Status Not done is not a valid status"])
      end
    end

    context "when the project does not exist" do
      # expectation: returns 404 not found
      it "returns 404 not found" do
        patch api_v1_project_path(1)

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json).to include("error" => "Project not found")
      end
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    context "when the project exists" do
      # expectation: deletes project, returns 200 OK
      let!(:project) { FactoryBot.create(:project) }

      it "deletes project returns 200 OK" do
        delete api_v1_project_path(project.id)

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq(nil)
        expect(json).to include("message" => "Project deleted successfully")
      end
    end

    context "when the project does not exist" do
      # expectation: returns 404 not found
      it "returns 404 not found" do
        delete api_v1_project_path(1)

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json).to include("error" => "Project not found")
      end
    end
  end
end
