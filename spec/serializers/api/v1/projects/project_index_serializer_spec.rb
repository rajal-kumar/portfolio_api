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

  subject { described_class.new(project).as_json }

  it "includes truncated summary" do
    expect(subject[:summary].length).to be <= 50
    expect(subject[:summary]).to eq(project.description.truncate(50))
  end

  it "includes nested urls" do
    expect(subject[:urls]).to eq({
      repo: "https://repo.com",
      live: "https://live.com"
    })
  end

  it "includes tech_stack mapped from technology_stack" do
    expect(subject[:tech_stack]).to eq("Rails")
  end
end



