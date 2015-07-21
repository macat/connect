require "rails_helper"

describe NetSuite::AttributeMapper do
  let(:netsuite_attribute_mapper) do
    NetSuite::AttributeMapper.new(
      attribute_mapper: NetSuite::AttributeMapperBuilder.new(
        user: create(:user),
      ).build,
      configuration: {}
    )
  end

  describe "delegation" do
    subject { netsuite_attribute_mapper }
    it { should delegate_method(:field_mappings).to(:attribute_mapper) }
    it { should delegate_method(:mapping_direction).to(:attribute_mapper) }
  end

  describe "#call" do
    it "returns a converted data structure based on field mappings" do
      field_mappings = netsuite_attribute_mapper.field_mappings
      export_profile_keys = field_mappings.map(&:integration_field_name)

      export_ready_profile = netsuite_attribute_mapper.call(profile)

      expect(export_ready_profile.keys).to match_array(export_profile_keys)
    end

    it "sets expected values in the profile" do
      export_ready_profile = netsuite_attribute_mapper.call(profile)

      expect(export_ready_profile.values).to match_array(profile.values)
    end

    it "doesn't map empty values" do
      delete_keys = %w(email last_name)
      trimmed_profile = profile
      delete_keys.each { |key| trimmed_profile.delete(key) }
      field_mappings = netsuite_attribute_mapper.field_mappings
      deleted_field_mappings = field_mappings.select do |mapping|
        delete_keys.member?(mapping.namely_field_name)
      end

      deleted_import_fields = deleted_field_mappings.map(
        &:integration_field_name
      )

      export_ready_profile = netsuite_attribute_mapper.call(trimmed_profile)

      expect(deleted_import_fields.to_set).not_to be_subset(
        export_ready_profile.keys.to_set
      )
    end
  end

  def profile
    {
      "email" => "test@example.com",
      "first_name" => "First",
      "gender" => "female",
      "home_phone" => "212-555-1212",
      "last_name" => "Last"
    }
  end
end
