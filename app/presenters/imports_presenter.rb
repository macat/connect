class ImportsPresenter
  def initialize(import_results)
    @import_results = import_results
  end

  def imported_candidates
    @imported_candidates ||= successful_results.map do |import_result|
      import_result[:candidate]
    end
  end

  def not_imported_candidates
    @not_imported_candidates ||= errored_results.map do |import_result|
      FailedImportCandidatePresenter.new(
        import_result[:candidate],
        import_result[:result].error,
      )
    end
  end

  def errors
    import_results.error
  end

  private

  attr_reader :import_results

  def successful_results
    import_results.to_a.select do |import_result|
      import_result[:result].success?
    end
  end

  def errored_results
    import_results.to_a.select do |import_result|
      !import_result[:result].success?
    end
  end
end
