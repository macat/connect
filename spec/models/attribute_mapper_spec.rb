require "rails_helper"

describe AttributeMapper do
  describe "validations" do
    it { should validate_presence_of(:user) }
  end

  describe "associations" do
    it { should belong_to(:user).dependent(:destroy) }
    it { should have_many(:field_mappings) }
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
end
