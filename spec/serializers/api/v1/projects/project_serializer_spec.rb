require "rails_helper"

RSpec.describe Api::V1::Projects::ProjectSerializer do
  subject { described_class.new(project).as_json }

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

  it "includes all expected fields" do
    expect(subject).to include(
      id: project.id,
      title: project.title,
      description: project.description,
      status: project.status,
      technology_stack: project.technology_stack,
      repository_url: project.repository_url,
      live_url: project.live_url,
      notes: project.notes,
      created_at: project.created_at,
      updated_at: project.updated_at
    )
  end
end
