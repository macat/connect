module NetSuite
  class Client
    BASE_URL = "https://api.cloud-elements.com/elements/api-v2"

    def initialize(user_secret:, organization_secret:)
      @user_secret = user_secret
      @organization_secret = organization_secret
    end

    def create_instance(params)
      post_json(
        "/instances",
        "configuration" => {
          "user.username" => params[:email],
          "user.password" => params[:password],
          "netsuite.accountId" => params[:account_id],
          "netsuite.sandbox" => false
        },
        "element" => {
          "key" => "netsuiteerp"
        },
        "tags" => [],
        "name" => "#{params[:account_id]}_netsuite"
      )
    end

    private

    def post_json(path, data)
      wrap_response do
        RestClient.post(
          url("/instances"),
          data.to_json,
          authorization: authorization,
          content_type: "application/json"
        )
      end
    end

    def wrap_response
      response = yield
      Result.new(true, response)
    rescue RestClient::BadRequest => exception
      Result.new(false, exception.response)
    end

    def url(path)
      "#{BASE_URL}#{path}"
    end

    def authorization
      "User #{@user_secret}, Organization #{@organization_secret}"
    end

    class Result
      def initialize(success, response)
        @success = success
        @response = response
      end

      def success?
        @success
      end

      def [](attribute)
        json[attribute]
      end

      private

      def json
        @json ||= JSON.parse(@response).with_indifferent_access
      end
    end

    private_constant :Result
  end
end
