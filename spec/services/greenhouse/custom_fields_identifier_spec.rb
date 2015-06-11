require_relative "../../../app/services/greenhouse/custom_fields_identifier"

describe Greenhouse::CustomFieldsIdentifier do
  let(:fields_identifier) { described_class.new(payload) }
  let(:payload) do
    {
      "application" => {
        "candidate" => {
          "custom_fields" => {
            "favorite_languages" => { "value" => "" },
            "level" => { "value" => "" }
          }
        },
        "job" => {
          "custom_fields" => {
            "offer" => { "value" => "" }
          }
        },
        "offer" => {
          "custom_fields" => {
            "another_offer" => { "value" => "" }
          }
        }
      }
    }
  end

  describe '#field_names' do
    it "returns the custom field names found" do
      expect(fields_identifier.field_names).to eql [:favorite_languages,
                                                    :level, :offer, :another_offer]
    end
  end
end
