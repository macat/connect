module Icims
  class CandidateSearch
    HIREDATE_FIELD = "person.employeeinfo.hiredate"

    def initialize(connection:, authorized_request: Icims::AuthorizedRequest)
      @connection = connection
      @authorized_request = authorized_request
    end

    def all
      JSON.parse(search_people)
    end

    private

    attr_reader :connection, :authorized_request

    def search_people
      authorized_request.new(
        request: search_people_request,
        connection: connection,
      ).execute
    end

    def search_people_request
      RestClient::Request.new(
        method: :post,
        url: "#{connection.api_url}/search/people",
        payload: search_params.to_json,
      )
    end

    def search_params
      {
        filters: [
          {
            name: HIREDATE_FIELD,
            operator: "=",
          }
        ]
      }
    end
  end
end
