require_relative '../../../app/services/greenhouse/custom_fields_identifier'

describe Greenhouse::CustomFieldsIdentifier do
  let(:fields_identifier) { described_class.new(payload) }
  let(:payload) do
    {
      'application' => {
        'candidate' => {
          'custom_fields' => {
            'favorite_languages' => { 'value' => '' },
            'level' => { 'value' => '' }
          }
        },
        'job' => {
          'custom_fields' => {
            'offer' => { 'value' => '' }
          }
        }
      }
    }
  end

  describe '#fields_name' do
    it 'returns the custom field names found' do
      expect(fields_identifier.fields_name).to eql [:favorite_languages,
                                                    :level, :offer]
    end
  end
end
