require_relative '../../../app/policies/greenhouse/valid_requester_policy'

describe Greenhouse::ValidRequesterPolicy do 
  subject(:policy) { described_class.new(connection, signature, payload).valid? }
  let(:connection) { double :connection, 
                     secret_key: 'mysignature' }
  let(:payload) do 
    JSON.parse(
        File.read("spec/fixtures/api_requests/greenhouse_payload_ping.json"))
  end

  describe '#valid?' do 
    context 'for valid digest in the high nibble' do 
      let(:signature) { 'sha256 7c051a394b3de31bd493403ca07b96a1e99518321724a882ade6d03a24e0f396' }
      it { is_expected.to be_truthy }
    end
  end
end
