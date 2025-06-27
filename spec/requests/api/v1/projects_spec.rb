require "rails_helper"

RSpec.describe "Projects API", type: :request do
  # let(:user) { create(:user) } when auth is added later
  let(:valid_project) { FactoryBot.create(:project) }

  let(:json_response) { JSON.parse(response.body.dup) }

  describe "GET /api/v1/projects" do
    context "when projects exist" do
      before { valid_project }

      it "returns a list of projects with status 200 OK" do
        get api_v1_projects_path

        expect(response).to have_http_status(:ok)

        expect(json_response).to be_an(Array)
        expect(json_response.first["title"]).to eq(valid_project.title)
      end
    end

    context "when no projects exist" do
      it "returns an empty array with 200 OK" do
        get api_v1_projects_path

        expect(response).to have_http_status(:ok)

        expect(json_response).to be_an(Array)
        expect(json_response).to eq([])
      end
    end
  end

  describe "GET /api/v1/projects/:id" do
    context "when the project exists" do
      it "returns the project with 200 OK" do
        get api_v1_project_path(valid_project.id)

        expect(response).to have_http_status(:ok)

        expect(json_response["id"]).to eq(valid_project.id)
        expect(json_response["title"]).to eq(valid_project.title)
      end
    end

    context "when the project does not exist" do
      it "returns 404 not found" do
        get api_v1_project_path(99999999)

        expect(response).to have_http_status(:not_found)

        expect(json_response).to include("error" => "Project not found")
      end
    end
  end

  describe "POST /api/v1/projects" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          project: {
            title: "test_proj",
            description: "Simple",
            status: "in_progress",
            technology_stack: "RoR",
            repository_url: "www.shouldbeasite.com"
          }
        }
      end
      it "responds with a created status" do
        expect { post api_v1_projects_path, params: valid_params }.to change(Project, :count).by(1)

        expect(response).to have_http_status(:created)

        expect(json_response["status"]).to eq("in_progress")
      end
    end

    context "with invalid parameters" do
      it "responds with unprocessable_entity status" do
        params = {
          description: "",
          technology_stack: 1,
          repository_url: "www.shouldbeasite.com",
        }

        post api_v1_projects_path, params: { project: params }

        expect(response).to have_http_status(:unprocessable_entity)

        expect(json_response["errors"]).to include("Title can't be blank")
      end
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    context "when the project exists and params are valid" do
      it "updates project returns 200 OK" do
        patch api_v1_project_path(valid_project.id), params: { project: {title: "Updated title", notes: "Added some note"}}

        expect(response).to have_http_status(:ok)

        expect(json_response["id"]).to eq(valid_project.id)
        expect(json_response["title"]).to eq("Updated title")
        expect(json_response["notes"]).to eq("Added some note")
      end
    end

    context "when the project exists but params are invalid" do
      it "returns 422 unprocessable entity" do
        patch api_v1_project_path(valid_project.id), params: { project: {status: "Not done"}}

        expect(response).to have_http_status(:unprocessable_entity)

        expect(json_response).to include("errors" => ["Status Not done is not a valid status"])
      end
    end

    context "when the project does not exist" do
      it "returns 404 not found" do
        patch api_v1_project_path(1)

        expect(response).to have_http_status(:not_found)

        expect(json_response).to include("error" => "Project not found")
      end
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    context "when the project exists" do
      before { valid_project }

      it "deletes project returns 200 OK" do
        delete api_v1_project_path(valid_project.id)

        expect(response).to have_http_status(:ok)

        expect(json_response).to include("message" => "Project deleted successfully")
        expect(Project.find_by(id: valid_project.id)).to be_nil
      end
    end

    context "when the project does not exist" do
      it "returns 404 not found" do
        delete api_v1_project_path(1)

        expect(response).to have_http_status(:not_found)

        expect(json_response).to include("error" => "Project not found")
      end
    end
  end
end
