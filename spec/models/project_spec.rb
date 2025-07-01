require 'rails_helper'

RSpec.describe Project, type: :model do
  subject(:project) { build(:project) }

  describe "factory" do
    context "should Validate" do
      it "is valid with valid attributes" do
        expect(project).to be_valid
      end
    end
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should define_enum_for(:status).with_values(%i[pending in_progress completed]) }
    it { should validate_presence_of(:technology_stack) }
    it { should validate_presence_of(:repository_url) }

    context "when no value is given for title" do
      let(:project) { Project.new(title: "", description: "Test", status: "in_progress", technology_stack: "RoR", repository_url: "http://example.com") }

      it "rejects invalid value" do
        expect(project).not_to be_valid
        expect(project.errors[:title]).to include("can't be blank")
      end
    end

    context "when given an invalid enum value" do
      it "raises an ArgumentError" do
        expect {
          Project.new(status: "not_a_real_status")
        }.to raise_error(ArgumentError)
      end
    end
  end
end
