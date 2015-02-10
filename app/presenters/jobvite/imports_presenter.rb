module Jobvite
  class ImportsPresenter
    def initialize(import_results)
      @import_results = import_results
    end

    def imported_candidates
      import_results.to_a.map do |import_result|
        import_result[:candidate] if import_result[:result].empty? 
      end.compact
    end

    private 

    attr_reader :import_results
  end
end
