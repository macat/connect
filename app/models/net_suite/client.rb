module NetSuite
  class Client
    BASE_URL = "https://api.cloud-elements.com/elements/api-v2"

    def self.from_env
      new(
        user_secret: ENV["CLOUD_ELEMENTS_USER_SECRET"],
        organization_secret: ENV["CLOUD_ELEMENTS_ORGANIZATION_SECRET"]
      )
    end

    def initialize(user_secret:, organization_secret:, element_secret: nil)
      @user_secret = user_secret
      @organization_secret = organization_secret
      @element_secret = element_secret
    end

    def authorize(element_secret)
      self.class.new(
        user_secret: @user_secret,
        organization_secret: @organization_secret,
        element_secret: element_secret
      )
    end

    def create_instance(params)
      submit_json(
        :post,
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

    def create_employee(params)
      submit_json(
        :post,
        "/hubs/erp/employees",
        params
      )
    end

    def update_employee(id, params)
      submit_json(
        :patch,
        "/hubs/erp/employees/#{id}",
        params
      )
    end

    def subsidiaries
      get_json("/hubs/erp/lookups/subsidiary")
    end

    private

    def submit_json(method, path, data)
      wrap_response do
        RestClient.public_send(
          method,
          url(path),
          data.to_json,
          authorization: authorization,
          content_type: "application/json"
        )
      end
    end

    def get_json(path)
      wrap_response do
        RestClient.get(
          url(path),
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
      secrets.
        compact.
        map { |name, secret| [name, secret].join(" ") }.
        join(", ")
    end

    def secrets
      {
        "User" => @user_secret,
        "Organization" => @organization_secret,
        "Element" => @element_secret
      }
    end

    class Result
      include Enumerable

      def initialize(success, response)
        @success = success
        @response = response
      end

      def success?
        @success
      end

      def [](attribute)
        json[attribute.to_s]
      end

      def each(&block)
        json.each(&block)
      end

      private

      def json
        @json ||= JSON.parse(@response)
      end
    end

    private_constant :Result
  end
end
