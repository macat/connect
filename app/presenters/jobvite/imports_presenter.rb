module Jobvite
  class ImportsPresenter
    def initialize(import_results)
      @import_results = import_results
    end

    def imported_candidates
      import_results.to_a.map do |import_result|
        import_result[:candidate] if import_result[:result] == I18n.t("status.success")
      end.compact
    end

    def not_imported_candidates
      import_results.to_a.map do |import_result| 
        format_error_message(import_result) if import_result[:result] =~ /error/i
      end.compact
    end

    private 

    def format_error_message(import_result)
      import_result[:result] = import_result[:result].split(":")[-1]
      import_result
    end

    attr_reader :import_results
  end
end
