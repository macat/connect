require_relative '../../../app/presenters/icims/candidate_retry_imports_presenter'

describe Icims::CandidateRetryImportsPresenter do
  subject(:presenter) { described_class.new(candidate, imported_result) }

  describe '#successful_import?' do
    let(:candidate) { double :candidate }

    context 'when imported_result is not nil' do
      let(:imported_result) { double :imported_result, success?: false }

      it 'return imported_result success value' do
        expect(presenter.successful_import?).to eql imported_result.success?
      end
    end

    context 'when imported_result is nil' do
      let(:imported_result) { nil }

      it 'return false' do
        expect(presenter.successful_import?).to eql false
      end
    end
  end

  describe '#candidate_name' do
    let(:imported_result) { double :imported_result, success?: false }

    context 'when candidate is not nil' do
      let(:candidate) { double :candidate, name: 'Candidate' }

      it 'return the candidate name' do
        expect(presenter.candidate_name).to eql candidate.name
      end
    end

    context 'when candidate is nil' do
      let(:candidate) { nil }

      it 'return blank' do
        expect(presenter.candidate_name).to eql ''
      end
    end
  end

  describe '#import_error' do
    let(:candidate) { double :candidate }

    context 'when imported_result is not nil' do
      let(:imported_result) { double :imported_result, error: 'My error'}

      it 'return imported_result error' do
        expect(presenter.import_error).to eql imported_result.error
      end
    end

    context 'when imported_result is nil' do
      let(:imported_result) { nil }

      it 'return a message to check on users email' do
        expect(presenter.import_error).to eql 'Check your email for details on errors'
      end
    end
  end
end
