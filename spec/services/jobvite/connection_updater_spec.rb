require 'spec_helper' 

describe Connect::Jobvite::ConnectionUpdater do 
  let(:jobvite_connection_repository) { double :repository }
  subject(:service) { described_class.new(jobvite_connection_repository) }

  describe '#update' do 
    let(:attributes) { {} }

    it 'trys to update the jobvite connection' do 
      expect(jobvite_connection_repository).to receive(:update).with(attributes)
      service.update(attributes)
    end

    context 'when hired workflow state is present' do 
      let(:attributes) { {hired_workflow_state: true} }

      it 'broadcast connection updated successfully' do 
        allow(jobvite_connection_repository).to receive(:update).with(attributes) { true }
        expect { service.update(attributes) }.to broadcast(:connection_updated_successfully) 
      end
    end

    context 'when hired workflow state is not present' do 
      let(:attributes) { {} }

      it 'broadcast connection updated successfully' do 
        allow(jobvite_connection_repository).to receive(:update).with(attributes) { false }
        expect { service.update(attributes) }.to broadcast(:connection_updated_unsuccessfully) 
      end
    end
  end
end
