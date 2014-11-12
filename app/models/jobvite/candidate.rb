require "ostruct"

module Jobvite
  class Candidate < OpenStruct
    def initialize(attributes)
      super attributes.map { |k,v| [k.underscore, v] }.to_h
    end

    def start_date
      unix_timestamp = application["startDate"] / 1000
      DateTime.strptime(unix_timestamp.to_s, "%s")
    end

    def gender
      application["gender"]
    end
  end
end
