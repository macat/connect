module Icims
  class CandidateRetryImportsPresenter
    DEFAULT_ERROR_MESSAGE = 'Check your email for details on errors'

    def initialize(candidate, imported_result)
      @candidate = candidate
      @imported_result = imported_result
    end

    def successful_import?
      if imported_result
        imported_result.success?
      else
        false
      end
    end

    def candidate_name
      if candidate
        candidate.name
      else
        ''
      end
    end

    def import_error
      if imported_result
        imported_result.error
      else
        DEFAULT_ERROR_MESSAGE
      end
    end

    private

    attr_reader :imported_result, :candidate
  end
end
