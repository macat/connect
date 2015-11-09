class NetSuite::DiffNormalizer

  def initialize(employee)
    @employee = employee.dup
  end

  def self.normalize(employee)
    new(employee).normalize
  end

  def normalize
    address = employee['addressbookList']["addressbook"].find do |address|
      address["defaultShipping"] == true
    end["addressbookAddress"]

    #TODO: Handle country!
    employee["defaultAddress"] = "#{ address["addr1"] }<br>#{ address["addr2"] }<br>#{ address["city"] } #{ address["state"] } #{ address["zip"] }<br>United States"
    
    employee
  end

  private

  attr_reader :employee
end 