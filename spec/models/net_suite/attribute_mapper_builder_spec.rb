require "rails_helper"

describe NetSuite::AttributeMapperBuilder do
  let(:builder) do
    NetSuite::AttributeMapperBuilder.new(user: create(:user))
  end

  describe "AttributeMapper" do
    it "returns an AttributeMapper" do
      attribute_mapper = builder.build

      expect(attribute_mapper).to be_an_instance_of(AttributeMapper)
    end

    it "persists the AttributeMapper" do
      attribute_mapper = builder.build

      expect(attribute_mapper).to be_persisted
    end
  end

  describe "#build_field_mappings" do
    it "has a FieldMapping for each default field" do
      attribute_mapper = builder.build

      integration_mappings = attribute_mapper.field_mappings.map(
        &:integration_field_name
      )
      namely_mappings = attribute_mapper.field_mappings.map(
        &:namely_field_name
      )

      expect(integration_mappings).to match_array(
        builder.default_field_mapping.values
      )
      expect(namely_mappings).to match_array(
        builder.default_field_mapping.keys
      )
    end
  end
end
