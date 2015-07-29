require "rails_helper"

describe AttributeMapper do
  describe "validations" do
    it { should validate_presence_of(:user) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:field_mappings).dependent(:destroy) }
  end

  describe "#build_field_mappings" do
    let(:attribute_mapper) do
      AttributeMapper.new(
        user: create(:user)
      )
    end

    let(:default_field_mapping) do
      {
        "email" => "email",
        "first_name" => "firstName",
        "gender" => "gender",
        "home_phone" => "phone",
        "last_name" => "lastName",
      }
    end

    it "has a FieldMapping for each default field" do
      attribute_mapper.save
      attribute_mapper.build_field_mappings(default_field_mapping)

      integration_mappings = attribute_mapper.field_mappings.map(
        &:integration_field_name
      )
      namely_mappings = attribute_mapper.field_mappings.map(
        &:namely_field_name
      )

      expect(integration_mappings).to match_array(default_field_mapping.values)
      expect(namely_mappings).to match_array(default_field_mapping.keys)
    end

    it "persists the FieldMappings" do
      attribute_mapper.save
      attribute_mapper.build_field_mappings(default_field_mapping)

      expect(
        attribute_mapper.field_mappings.reject(&:persisted?)
      ).to be_empty
    end
  end

  describe "#namely_fields" do
    it "returns mappable fields from a Namely connection" do
      ["single_select", "short_text", "long_text", "number"]
      models = [
        double(name: "first_name", label: "First name", type: "text"),
        double(name: "last_name", label: "Last name", type: "longtext"),
        double(name: "gender", label: "Gender", type: "select"),
        double(name: "email", label: "Email", type: "email"),
        double(name: "job_title", label: "Job title", type: "referencehistory"),
        double(name: "user_status", label: "Status", type: "referenceselect"),
        stub_profile_field(type: "address"),
        stub_profile_field(type: "checkboxes"),
        stub_profile_field(type: "date"),
        stub_profile_field(type: "file"),
        stub_profile_field(type: "image"),
        stub_profile_field(type: "salary"),
      ]
      fields = double("fields", all: models)
      user = build_stubbed(:user)
      allow(user).to receive(:namely_fields).and_return(fields)
      attribute_mapper = AttributeMapper.new(user: user)

      result = attribute_mapper.namely_fields

      expect(result).to eq([
        ["First name", "first_name"],
        ["Last name", "last_name"],
        ["Gender", "gender"],
        ["Email", "email"],
        ["Job title", "job_title"],
        ["Status", "user_status"]
      ])
    end

    def stub_profile_field(type:)
      double(name: type, label: "#{type} field", type: type)
    end
  end
end
