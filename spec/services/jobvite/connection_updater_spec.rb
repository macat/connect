require 'spec_helper' 

describe Connect::Jobvite::ConnectionUpdater do 
  let(:jobvite_connection_repository) { double :repository }
  subject(:service) { described_class.new(attributes, jobvite_connection_repository) }

  describe '#update' do 
    let(:attributes) { {} }
    let(:success) { ->() { 'success' } }
    let(:failure) { ->() { 'failure' } }

    it 'trys to update the jobvite connection' do 
      expect(jobvite_connection_repository).to receive(:update).with(attributes)
      service.update(success: success, failure: failure)
    end

    context 'when hired workflow state is present' do 
      let(:attributes) { {hired_workflow_state: true} }

      it 'broadcast connection updated successfully' do 
        allow(jobvite_connection_repository).to receive(:update).with(attributes) { true }
        expect(service.update(success: success, failure: failure)).to eql 'success'
      end
    end

    context 'when hired workflow state is not present' do 
      let(:attributes) { {} }

      it 'broadcast connection updated successfully' do 
        allow(jobvite_connection_repository).to receive(:update).with(attributes) { false }
        expect(service.update(success: success, failure: failure)).to eql 'failure'
      end
    end
  end
end
