require "ostruct"

module Icims
  class Candidate < OpenStruct
    def initialize(attributes)
      super attributes.map { |k,v| [k.underscore, v] }.to_h
    end

    def start_date
      if has_start_date?
        Date.parse(startdate).iso8601
      end
    end

    def name
      [firstname, lastname].join(" ")
    end

    def contact_number
      phone_numbers["Home"] || phone_numbers["Work"] || phone_numbers["Mobile"]
    end

    def to_partial_path
      "icims_imports/candidate"
    end

    def home_address
      HomeAddress.new(addresses).home_address
    end

    def salary
      if icims_salary
        {
          currency: icims_salary["currency"],
          date: start_date,
          yearly_amount: icims_salary["amount"].to_s,
        }
      end
    end

    private

    def phone_numbers
      @phone_numbers ||= phones.inject({}) do |hash, phone|
        hash[phone["phonetype"]["value"]] = phone["phonenumber"]
        hash
      end
    end

    def phones
      @phones || []
    end

    def has_start_date?
      startdate.present?
    end

    def icims_salary
      self[:salary]
    end
  end
end
