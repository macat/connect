module Icims
  class Client
    class Error < StandardError
    end

    attr_reader :connection

    def self.recent_hires(connection)
      new(connection).recent_hires
    end

    def initialize(connection)
      @connection = connection
    end

    def recent_hires
      CandidateSearch.all(connection)
    end

    private

    class CandidateSearch
      def self.all(connection)
        new(connection).candidates
      end

      def initialize(connection)
        @connection = connection
      end

      def candidates
        if all_candidates.has_key?("errors")
          raise Error, all_candidates["errors"]
        else
          map_candidates
        end
      end

      private

      attr_reader :connection

      def search_people
        RestClient.post(
          "#{connection.api_url}/search/people",
          { data: search_params }.merge(authorized_params),
        )
      end

      def authorized_params
        { key: connection.key }
      end

      def get_candidate(person_id)
        JSON.parse(RestClient.get("#{connection.api_url}/people/#{person_id}"))
      end

      def all_candidates
        @all_candidate ||= JSON.parse(search_people)
      end

      def map_candidates
        all_candidates.fetch("searchResults", []).map do |hash|
          Candidate.new(get_candidate(hash["id"]).merge(hash))
        end
      end

      def search_params
        {
          filters: [
            {
              name: "person.employeeinfo.hiredate",
              operator: "=",
            }
          ]
        }
      end
    end
    private_constant :CandidateSearch
  end
end
