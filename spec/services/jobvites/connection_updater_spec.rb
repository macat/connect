require 'spec_helper' 

describe Jobvites::ConnectionUpdater do 
  let(:jobvite_connection_repository) { double :repository }
  subject(:service) { described_class.new(attributes, jobvite_connection_repository) }

  describe '#update' do 
    let(:attributes) { {} }

    it 'trys to update the jobvite connection' do 
      expect(jobvite_connection_repository).to receive(:update).
        with(attributes) { true }
      service.update
    end

    context 'when hired workflow state is present' do 
      let(:attributes) { {hired_workflow_state: true} }

      it 'broadcast connection updated successfully' do 
        allow(jobvite_connection_repository).to receive(:update).
          with(attributes) { true }
        expect(service.update).to eql true
      end
    end

    context 'when hired workflow state is not present' do 
      let(:attributes) { {} }

      it 'raise an error' do 
        allow(jobvite_connection_repository).to receive(:update).
          with(attributes) { false }
        expect{ 
          service.update 
        }.to raise_error(Jobvites::ConnectionUpdater::UpdateFailed)
      end
    end
  end
end
