require "rails_helper"

describe NetSuite::AttributeMapper do
  let(:configuration) { double("configuration", subsidiary_id: "123") }
  let(:netsuite_attribute_mapper) do
    NetSuite::AttributeMapper.new(
      attribute_mapper: NetSuite::AttributeMapperBuilder.new(
        user: create(:user),
      ).build,
      configuration: configuration
    )
  end

  describe "delegation" do
    subject { netsuite_attribute_mapper }
    it { should delegate_method(:field_mappings).to(:attribute_mapper) }
    it { should delegate_method(:mapping_direction).to(:attribute_mapper) }
  end

  describe "#export" do
    it "returns a converted data structure based on field mappings" do
      field_mappings = netsuite_attribute_mapper.field_mappings
      export_profile_keys = field_mappings.map(&:integration_field_name)

      export_attributes = export

      expect(
        export_attributes.keys.to_set
      ).to be_superset(export_profile_keys.to_set)
    end

    it "doesn't map empty values" do
      delete_keys = [:email, :last_name]
      profile_data = stubbed_profile_data
      delete_keys.each { |key| profile_data[key] = nil }

      export_attributes = export(profile_data)

      expect(export_attributes).not_to have_key("email")
      expect(export_attributes).not_to have_key("lastName")
    end

    describe "value handling" do
      it "sets expected values in the profile for regular attributes" do
        attributes = {
          email: "test@example.com",
          first_name: "First",
          home_phone: "919-555-1212",
          last_name: "Last",
        }

        profile_data = stubbed_profile_data.merge(attributes)

        export_attributes = export(profile_data)

        expect(export_attributes["email"]).to eq(attributes[:email])
        expect(export_attributes["firstName"]).to eq(attributes[:first_name])
        expect(export_attributes["phone"]).to eq(attributes[:home_phone])
        expect(export_attributes["lastName"]).to eq(attributes[:last_name])
      end
    end

    context "gender mapping" do
      it "maps 'Female to _female'" do
        profile_data = stubbed_profile_data.merge(gender: "Female")

        export_attributes = export(profile_data)

        expect(export_attributes["gender"]).to eq("_female")
      end

      it "maps 'Male to _male'" do
        profile_data = stubbed_profile_data.merge(gender: "Male")

        export_attributes = export(profile_data)

        expect(export_attributes["gender"]).to eq("_male")
      end

      it "maps nil to '_omitted'" do
        profile_data = stubbed_profile_data.merge(gender: nil)

        export_attributes = export(profile_data)

        expect(export_attributes["gender"]).to eq("_omitted")
      end

      it "maps an empty string to '_omitted'" do
        profile_data = stubbed_profile_data.merge(gender: "")

        export_attributes = export(profile_data)

        expect(export_attributes["gender"]).to eq("_omitted")
      end
    end

    context "job title" do
      it "extracts the job_title name" do
        title = "Robot"
        job_title = stubbed_job_title(title)
        profile_data = stubbed_profile_data.merge(job_title)

        export_attributes = export(profile_data)

        expect(export_attributes["title"]).to eq(title)
      end

      context "nil value" do
        it "sets an empty string" do
          job_title = stubbed_job_title("")
          profile_data = stubbed_profile_data.merge(job_title)

          export_attributes = export(profile_data)

          expect(export_attributes["title"]).to eq("")
        end
      end
    end

    context "subsidiary_id" do
      it "provides a subsidiary_id from the configuration" do
        export_attributes = export

        expect(
          export_attributes["subsidiary"]
        ).to eq("internalId" => configuration.subsidiary_id)
      end
    end
  end

  def export(profile_data = stubbed_profile_data)
    netsuite_attribute_mapper.export(stubbed_profile(profile_data))
  end

  def stubbed_profile_data
    {
      email: "test@example.com",
      first_name: "First",
      gender: "Female",
      home_phone: "212-555-1212",
      last_name: "Last"
    }.merge(stubbed_job_title("Robot"))
  end

  def stubbed_job_title(title)
    {
      job_title: {
        "id" => "1234",
        "title" => title
      }
    }
  end

  def stubbed_profile(data = stubbed_profile_data)
    double(:profile, data)
  end
end
