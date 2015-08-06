require "rails_helper"

describe NetSuite::EmployeeFieldsLoader do
  describe "#retrieve_fields" do
    it "gets a currest list of NetSuite employee profile fields" do
      stubbed_employee_data = stub_employee_data(
        expenseLimit: 100,
        firstName: "Ralph",
        hireDate: Time.now.to_i,
        isSalesRep: false,
        lastName: "Bot",
        officePhone: "212-555-1212",
        subsidiary: {}
      )

      stub_request(
        :get,
        "https://api.cloud-elements.com/elements/api-v2" \
        "/hubs/erp/employees?pageSize=5"
      ).with(
        headers: {
          "Authorization" => "User user-secret, " \
          "Organization org-secret, " \
          "Element element-secret",
          "Content-Type" => "application/json"
        }
      ).to_return(
        body: stubbed_employee_data.to_json,
        status: 200
      )

      request = NetSuite::Client.new(
        element_secret: "element-secret",
        organization_secret: "org-secret",
        user_secret: "user-secret",
      ).request

      loader = described_class.new(request: request)
      fields = loader.load_profile_fields
      labels = fields.map(&:label)
      types = fields.map(&:type)

      expected_labels = [
        "Expense Limit",
        "First Name",
        "Hire Date",
        "Is Sales Rep",
        "Last Name",
        "Office Phone",
        "Subsidiary"
      ]

      expected_labels.each do |expected_label|
        expect(labels).to include(expected_label)
      end

      %w(boolean date fixnum object text).each do |type|
        expect(types).to include(type)
      end
    end
  end

  def stub_employee_data(options = {})
    [
      {
        expenseLimit: 0,
        firstName: "First",
        hireDate: Time.now.to_i,
        isSalesRep: false,
        lastName: "Last",
        officePhone: "919-555-0000",
        subsidiary: {}
      }.merge(options).deep_stringify_keys
    ]
  end
end
