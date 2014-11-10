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
    CandidatePage.all(connection).flat_map { |page| page.candidates }
  end

  private

  attr_reader :connection

  class CandidatePage
    def self.all(connection)
      page = new(connection, 1)
      Enumerator.new do |yielder|
        while page
          yielder.yield page
          page = page.next
        end
      end
    end

    def initialize(connection, start)
      @connection = connection
      @start = start
    end

    def candidates
      if json_response.has_key?("errors")
        raise Error, json_response["errors"]["messages"].to_sentence
      else
        json_response.fetch("candidates").map { |hash| Candidate.new(hash) }
      end
    end

    def next
      unless last_page?
        self.class.new(connection, next_page_start)
      end
    end

    private

    attr_reader :connection, :start

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
        start: start,
        count: number_per_page,
        wflowstate: hired_workflow_state,
      }
    end

    def hired_workflow_state
      "Offer Accepted"
    end

    def last_page?
      json_response.fetch("total") < next_page_start
    end

    def next_page_start
      start + number_per_page
    end

    def number_per_page
      50
    end
  end
  private_constant :CandidatePage
end
