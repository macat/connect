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
      let(:signature) { 'sha256 798ffe4edc99af295e2b83e41005ec6be42078f36fd1c3dbcc6183d052e38dba' }
      it { is_expected.to be_truthy }
    end
  end
end
