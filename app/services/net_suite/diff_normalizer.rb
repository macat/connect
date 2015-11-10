class NetSuite::DiffNormalizer

  def initialize(employee)
    @employee = employee.dup
  end

  def self.normalize(employee)
    new(employee).normalize
  end

  def normalize
    employee["defaultAddress"] = ""

    if (addressbook_list = employee["addressbookList"]) &&
       (address_book = addressbook_list["addressbook"])

      default_address = address_book.find do |address|
        address["defaultShipping"] == true
      end

      if default_address.present? && address = default_address["addressbookAddress"]
        #TODO: Handle country!
        employee["defaultAddress"] = "#{ address["addr1"] }<br>#{ address["addr2"] }<br>#{ address["city"] } #{ address["state"] } #{ address["zip"] }<br>United States"
      end
    end

    employee
  end

  private

  attr_reader :employee
end
