require "rails_helper"

RSpec.describe Api::V1::Projects::ProjectIndexSerializer do
  let(:project) do
    Project.new(
      id: 1,
      title: "Test Project",
      description: "A" * 100,
      status: "in_progress",
      technology_stack: "Rails",
      repository_url: "https://repo.com",
      live_url: "https://live.com"
    )
  end

  let(:serialized) { described_class.new(project).as_json }

  describe "summary" do
    it "is truncated to 50 characters" do
      expect(serialized[:summary].length).to be <= 50
    end

    it "matches truncated version of description" do
      expect(serialized[:summary]).to eq(project.description.truncate(50))
    end
  end

  describe "urls" do
    it "includes nested repo and live URLs" do
      expect(serialized[:urls]).to eq({
        repo: "https://repo.com",
        live: "https://live.com"
      })
    end
  end

  describe "tech_stack" do
    it "matches technology_stack" do
      expect(serialized[:tech_stack]).to eq("Rails")
    end
  end
end
