module Icims
  class CandidateRetryImportsPresenter
    def initialize(candidate, imported_result)
      @candidate = candidate
      @imported_result = imported_result
    end

    def successful_import?
      imported_result.success? || false
    end

    def candidate_name
      candidate.name || ''
    end

    def import_error
      imported_result.error || 'Check your email for details on errors'
    end

    private

    attr_reader :imported_result, :candidate
  end
end
