module NetSuite
  # Wraps BadRequest errors from Cloud Elements. Attempts to parse a
  # human-readable error message from the response.
  class ApiError < StandardError
    def initialize(response)
      @response = response
    end

    def message
      response_data["providerMessage"] ||
        response_data["message"] ||
        "Unknown error"
    end

    private

    def response_data
      if @response.present?
        JSON.parse(@response)
      else
        {}
      end
    end
  end
end
