class FailedImportCandidatePresenter < SimpleDelegator
  attr_reader :error

  def initialize(candidate, error)
    super(candidate)
    @error = error
  end

  def email
    try(:email) || "noemail@example.com"
  end
end
