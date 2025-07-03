require "rails_helper"

RSpec.describe Api::V1::Projects::ProjectSerializer do
  subject(:serialized_project) { described_class.new(project).as_json }

  let(:project) do
    build_stubbed(
      :project,
      id: 1,
      title: "Full Project",
      description: "Detailed description",
      status: "completed",
      technology_stack: "Rails",
      repository_url: "https://github.com/example",
      live_url: "https://example.com",
      notes: "Finished project",
      created_at: Time.zone.now,
      updated_at: Time.zone.now
    )
  end

  it "includes the id and title" do
    expect(serialized_project).to include(
      id: project.id,
      title: project.title
    )
  end

  it "includes the description and status" do
    expect(serialized_project).to include(
      description: project.description,
      status: project.status
    )
  end

  it "includes URLs and notes" do
    expect(serialized_project).to include(
      repository_url: project.repository_url,
      live_url: project.live_url,
      notes: project.notes
    )
  end

  it "includes timestamps" do
    expect(serialized_project).to include(
      created_at: project.created_at,
      updated_at: project.updated_at
    )
  end
end
