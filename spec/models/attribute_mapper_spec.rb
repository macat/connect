require "rails_helper"

describe AttributeMapper do
  describe "associations" do
    it { should have_many(:field_mappings).dependent(:destroy) }
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
        integration_field_id: integration_field_name,
        integration_field_name: integration_field_name
      )
    end
  end
end
