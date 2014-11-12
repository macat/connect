require "ostruct"

module Jobvite
  class Candidate < OpenStruct
    def initialize(attributes)
      super attributes.map { |k,v| [k.underscore, v] }.to_h
    end

    def start_date
      Date.strptime(start_date_unix_timestamp.to_s, "%s").iso8601
    end

    def gender
      application["gender"]
    end

    private

    def start_date_unix_timestamp
      application["startDate"] / 1000
    end
  end
end
