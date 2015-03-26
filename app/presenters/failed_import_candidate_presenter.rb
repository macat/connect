class FailedImportCandidatePresenter < SimpleDelegator
  attr_reader :error

  def initialize(candidate, error)
    super(candidate)
    @error = error
  end
end
