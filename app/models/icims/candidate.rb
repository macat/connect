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
      phonenumber
    end

    private

    def has_start_date?
      startdate.present?
    end
  end
end
