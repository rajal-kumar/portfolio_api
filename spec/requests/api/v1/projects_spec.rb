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
      it "returns an empty array" do
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
    end

    context "when the project does not exist" do
      # expectation: returns 404 not found
    end
  end

  describe "POST /api/v1/projects" do
    context "with valid parameters" do
      # expectation: creates project and returns 201 created
    end

    context "with invalid parameters" do
      # expectation: returns 422 unprocessable entity with errors
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    context "when the project exists and params are valid" do
      # expectation: updates project, returns 200 OK
    end

    context "when the project exists but params are invalid" do
      # expectation: returns 422 unprocessable entity
    end

    context "when the project does not exist" do
      # expectation: returns 404 not found
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    context "when the project exists" do
      # expectation: deletes project, returns 200 OK
    end

    context "when the project does not exist" do
      # expectation: returns 404 not found
    end
  end
end
