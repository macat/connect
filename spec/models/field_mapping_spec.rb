require "rails_helper"

describe FieldMapping do
  describe "validations" do
    it { should validate_presence_of(:integration_field_name) }
    it { should validate_presence_of(:namely_field_name) }
    it { should validate_presence_of(:attribute_mapper) }
  end

  describe "associations" do
    it { should belong_to(:attribute_mapper) }
  end

  describe "#integration_key" do
    context "spaces" do
      it "underscores" do
        expect(integration_key(field_name: "integration field name")).
          to eq("integration_field_name")
      end
    end

    context "camelCase" do
      it "underscores" do
        expect(integration_key(field_name: "integrationFieldName")).
          to eq("integration_field_name")
      end
    end

    context "dash-case" do
      it "underscores" do
        expect(integration_key(field_name: "integration-field-name")).
          to eq("integration_field_name")
      end
    end
  end

  def integration_key(field_name:)
    FieldMapping.new(integration_field_name: field_name).integration_key
  end
end
