require 'rails_helper'

RSpec.describe Project, type: :model do
  subject(:project) { build(:project) }

  describe "factory" do
    context "when validating presence" do
      it "has valid attributes" do
        expect(project).to be_valid
      end
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to define_enum_for(:status).with_values(%i[pending in_progress completed]) }
    it { is_expected.to validate_presence_of(:technology_stack) }
    it { is_expected.to validate_presence_of(:repository_url) }

    context "when no value is given for title" do
      let(:project) { described_class.new(title: "", description: "Test", status: "in_progress", technology_stack: "RoR", repository_url: "http://example.com") }

      it "is invalid when title is blank" do
        expect(project).not_to be_valid
      end

      it "adds an error message for blank title" do
        project.valid?
        expect(project.errors[:title]).to include("can't be blank")
      end
    end

    context "when given an invalid enum value" do
      it "raises an ArgumentError" do
        expect {
          described_class.new(status: "not_a_real_status")
        }.to raise_error(ArgumentError)
      end
    end
  end
end
