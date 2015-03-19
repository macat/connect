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
        AuthorizedRequest.new(
          request: search_people_request,
          connection: connection,
        ).execute
      end

      def search_people_request
        RestClient::Request.new(
          method: :post,
          url: "#{connection.api_url}/search/people",
          data: search_params,
          headers: authorized_params,
        )
      end

      def get_candidate(person_id)
        AuthorizedRequest.new(
          connection: connection,
          request: get_candidate_request(person_id)
        ).execute
      end

      def get_candidate_request(person_id)
        RestClient::Request.new(
          method: :get,
          url: person_url(person_id),
          headers: authorized_params.merge(
            params: { fields: required_person_fields },
          ),
        )
      end

      def candidate(person_id)
        JSON.parse(get_candidate(person_id)).
          merge("id" => person_id)
      end

      def person_url(person_id)
        "#{connection.api_url}/people/#{person_id}"
      end

      def required_person_fields
        [
          "email",
          "firstname",
          "gender",
          "lastname",
          "startdate",
        ].join(",")
      end

      def authorized_params
        { key: connection.key }
      end

      def all_candidates
        @all_candidate ||= JSON.parse(search_people)
      end

      def map_candidates
        all_candidates.fetch("searchResults", []).map do |hash|
          Candidate.new(candidate(hash["id"]).merge(hash))
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
