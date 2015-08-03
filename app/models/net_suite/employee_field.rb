module NetSuite
  class EmployeeField
    attr_reader :name, :value

    def initialize(name:, value:)
      @name = name
      @value = value
    end

    def label
      name.titleize
    end

    def type
      TypeForField.for_field(name: name, value: value)
    end
  end
end
