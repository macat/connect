require 'spec_helper' 
require 'timecop'
require 'active_support/time'

describe Connect::Users::TokenExpiry do 
  describe '.for' do 
    let(:expiry_time) { 899 }

    it 'compute expiry time that many seconds in the future' do 
      Timecop.freeze Time.now do 
        expect(described_class.for(expiry_time)).to be_within(1.second).of(expiry_time.seconds.from_now)
      end
    end
  end
end
