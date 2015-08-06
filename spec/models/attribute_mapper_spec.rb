require "rails_helper"

describe AttributeMapper do
  describe "associations" do
    it { should have_many(:field_mappings).dependent(:destroy) }
  end

  describe "#build_field_mappings" do
    let(:attribute_mapper) { AttributeMapper.new }

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

  describe "#import" do
    it "maps field names" do
      field_mappings = map_fields(
        "first_name" => "firstName",
        "last_name" => "lastName",
        "birth_date" => "birthDate",
      )
      attribute_mapper = AttributeMapper.new(field_mappings: field_mappings)

      result = attribute_mapper.import(
        firstName: "First",
        lastName: "Last",
        birthDate: nil,
        unknown: "Unknown"
      )

      expect(result).to eq(
        first_name: "First",
        last_name: "Last"
      )
    end
  end

  def map_fields(fields)
    fields.map do |namely_field_name, integration_field_name|
      FieldMapping.new(
        namely_field_name: namely_field_name,
        integration_field_name: integration_field_name
      )
    end
  end
end
