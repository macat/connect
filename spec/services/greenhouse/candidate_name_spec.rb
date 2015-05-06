require_relative '../../../app/services/greenhouse/candidate_name'

describe Greenhouse::CandidateName do 
  subject(:candidate_name) { described_class.new(payload) }

  describe '#to_s' do 
    context 'when the payload contains application node' do 
      let(:payload) do 
        {
          'application' => {
            'candidate' => {
              'first_name' => "Rafael",
              'last_name' => "George"
            }
          }
        }
      end

      it 'returns a proper format for the candidate name' do 
        expect(candidate_name.to_s).to eql "Rafael George"
      end

      it 'formats for just first name' do 
        payload['application']['candidate']['last_name'] = nil
        expect(candidate_name.to_s).to eql "Rafael"
      end

      it 'formats for just last name' do 
        payload['application']['candidate']['first_name'] = nil
        expect(candidate_name.to_s).to eql "George"
      end
    end
  end
end
