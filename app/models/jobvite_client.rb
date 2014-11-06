require "ostruct"

class JobviteClient
  class Error < StandardError
  end

  class Candidate < OpenStruct
    def initialize(attributes)
      super attributes.map { |k,v| [k.underscore, v] }.to_h
    end
  end

  def self.recent_hires(connection)
    new(connection).recent_hires
  end

  def initialize(connection)
    @connection = connection
  end

  def recent_hires
    if json_response.has_key?("errors")
      raise Error, json_response["errors"]["messages"].to_sentence
    else
      json_response.fetch("candidates").map { |hash| Candidate.new(hash) }
    end
  end

  private

  attr_reader :connection

  def json_response
    @json_response ||= JSON.parse(RestClient.get(url))
  end

  def url
    "https://api.jobvite.com/api/v2/candidate?#{jobvite_compatible_query}"
  end

  def jobvite_compatible_query
    query_params.to_query.gsub("+", "%20")
  end

  def query_params
    {
      api: connection.api_key,
      sc: connection.secret,
      start: 1,
      count: 50,
      wflowstate: hired_workflow_state,
    }
  end

  def hired_workflow_state
    "Offer Accepted"
  end
end
