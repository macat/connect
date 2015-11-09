module NetSuite
  # Finds matching NetSuite employee and Namely profile pairs based on either a
  # netsuite_id or provided fields to match on (names or emails for example).
  class Matcher
    # @param fields [Array} List of Netsuite fields to match objects
    # @param namely_profiles [Array] Namely profile list
    # @param netsuite_employees [Array] Netsuite employee list
    def initialize(fields:, namely_employees:, netsuite_employees:)
      @fields = fields
      @employees = netsuite_employees
      @namely_employees = namely_employees
      @employees_by_id = Hash[@employees.map { |e| [e["InternalId"], e] }]
      @matched_pairs = []
      @unmatched_namely_employees = []
    end

    # Returns matched pairs of profiles
    # @return [Array] An array of hashes containing the profiles that were matched together
    def matched_pairs
      match_lists

      @matched_pairs
    end

    # Returns the namely profiles that could not be matched
    # @return [Array] Namely Profiles
    def unmatched_namely_employees
      match_lists
      
      @unmatched_namely_employees
    end

    private

    attr_reader :employees, :namely_employees, :employees_by_id, :mapper, :fields

    def match_lists
      return if @matched

      namely_employees.each do |namely_employee|
        employee = match_employee(namely_employee, employees)

        if employee
          @matched_pairs << { namely_employee: namely_employee, netsuite_employee: employee}
        else
          @unmatched_namely_employees << namely_employee
        end
      end

      @matched = true
    end

    def match_employee(namely_employee, employees)
      employee = nil
      if namely_employee["netsuite_id"] && @employees_by_id.has_key?(namely_employee["netsuite_id"])
        return employees_by_id[namely_employee["netsuite_id"]]
      else
        return employees.find do |employee|
          fields.all? { |field| employee[field] == namely_employee[field] }
        end
      end
    end
  end
end

