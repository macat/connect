module NetSuite
  # EmployeeDiffer takes a Namely Profile and NetSuite Employee and attempts
  # to figure out if there is a difference between the 2 based on simple
  # heuristics
  class EmployeeDiffer
    FIELD_CHECK = {
      first_name: "firstName",
      last_name: "lastName",
      middle_name: "middleName",
      email: "email",
    }

    # @param namely_profile An object representing a namely profile
    # @param netsuite_employee An object representing an employee record on NetSuite
    def initialize(namely_profile:, netsuite_employee:)
      @namely_profile = namely_profile
      @netsuite_employee = netsuite_employee
    end

    def different?
      !FIELD_CHECK.all? do |namely, netsuite|
        namely_value = normalize_value(@namely_profile.public_send(namely))
        netsuite_value = normalize_value(@netsuite_employee[netsuite])

        namely_value == netsuite_value
      end
    end

    private

    def normalize_value(value)
      case value
      when String
        value.strip.downcase
      else
        value
      end
    end
  end
end
