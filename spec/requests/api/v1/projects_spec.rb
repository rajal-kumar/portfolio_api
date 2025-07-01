require "rails_helper"

RSpec.describe "Projects API", type: :request do
  # let(:user) { create(:user) } when auth is added later
  let(:valid_project) { FactoryBot.create(:project) }

  let(:json_response) { JSON.parse(response.body.dup) }

  describe "GET /api/v1/projects" do
    context "when projects exist" do
      let(:project) { create(:project) }

      before { get api_v1_projects_path }

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a projects array" do
        expect(json_response["projects"]).to be_an(Array)
      end

      it "returns pagination metadata" do
        expect(json_response["meta"]).to include("current_page")
      end
    end

    context "when no projects exist" do
      before { get api_v1_projects_path }

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a hash response" do
        expect(json_response).to be_a(Hash)
      end

      it "returns a empty projects array" do
        expect(json_response["projects"]).to eq([])
      end
    end
  end

  describe "GET /api/v1/projects/:id" do
    context "when the project exists" do
      before { get api_v1_project_path(valid_project.id) }

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the correct project ID" do
        expect(json_response["id"]).to eq(valid_project.id)
      end

      it "returns the correct project title" do
        expect(json_response["title"]).to eq(valid_project.title)
      end
    end

    context "when the project does not exist" do
      before { get api_v1_project_path(99999999) }

      it "returns 404 not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found error message" do
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

      it "creates a new project" do
        expect { post api_v1_projects_path, params: valid_params }.to change(Project, :count).by(1)
      end

      it "returns 201 created" do
        post api_v1_projects_path, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it "returns correct status in response" do
        post api_v1_projects_path, params: valid_params
        expect(json_response["status"]).to eq("in_progress")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          project: {
            description: "",
            technology_stack: 1,
            repository_url: "www.shouldbeasite.com"
          }
        }
      end

      before { post api_v1_projects_path, params: invalid_params }

      it "returns 422 unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation error message" do
        expect(json_response["errors"]).to include("Title can't be blank")
      end
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    context "when the project exists and params are valid" do
      let!(:project) { valid_project }

      before do
        patch api_v1_project_path(project.id), params: {
          project: { title: "Updated title", notes: "Added some note" }
        }
      end

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the title" do
        expect(json_response["title"]).to eq("Updated title")
      end

      it "updates the notes" do
        expect(json_response["notes"]).to eq("Added some note")
      end
    end

    context "when the project exists but params are invalid" do
      before do
        patch api_v1_project_path(valid_project.id), params: { project: { status: "Not done" } }
      end

      it "returns 422 unprocessable entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns a status error message" do
        expect(json_response).to include("errors" => [ "'Not done' is not a valid status" ])
      end
    end

    context "when the project does not exist" do
      before { patch api_v1_project_path(999999) }

      it "returns 404 not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        expect(json_response).to include("error" => "Project not found")
      end
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    context "when the project exists" do
      let!(:project) { valid_project }

      it "returns 200 OK" do
        delete api_v1_project_path(project.id)
        expect(response).to have_http_status(:ok)
      end

      it "returns success message" do
        delete api_v1_project_path(project.id)
        expect(json_response).to include("message" => /deleted/i)
      end

      it "actually deletes the project" do
        delete api_v1_project_path(project.id)
        expect(Project.find_by(id: project.id)).to be_nil
      end
    end

    context "when the project does not exist" do
      before { delete api_v1_project_path(999999) }

      it "returns 404 not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        expect(json_response).to include("error" => "Project not found")
      end
    end
  end
end
