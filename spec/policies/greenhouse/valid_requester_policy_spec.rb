require_relative '../../../app/policies/greenhouse/valid_requester_policy'

describe Greenhouse::ValidRequesterPolicy do 
  subject(:policy) { described_class.new(connection, signature).valid? }
  let(:connection) { double :connection, secret_key: 'mysignature' }
  
  describe '#valid?' do 
    context 'for valid digest' do 
      let(:signature) { 'sha256 mysignature' }
      it { is_expected.to be_truthy }
    end
  end
end
