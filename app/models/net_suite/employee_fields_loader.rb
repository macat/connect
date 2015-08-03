module NetSuite
  class EmployeeFieldsLoader
    EMPLOYEE_LIMIT = 5

    def initialize(request:)
      @request = request
    end

    def load_profile_fields
      employees = request.get_json(
        "#{NetSuite::Client::EMPLOYEE_REQUEST}?pageSize=#{EMPLOYEE_LIMIT}"
      )

      convert_employee_data_to_profile_fields(employees.first)
    end

    def convert_employee_data_to_profile_fields(employee)
      employee.map do |name, value|
        NetSuite::EmployeeField.new(name: name, value: value)
      end
    end

    private

    attr_reader :request
  end
end
