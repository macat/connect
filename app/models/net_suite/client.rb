module NetSuite
  class Client
    delegate :get_json, to: :request
    delegate :submit_json, to: :request

    def self.from_env(user)
      new(
        user: user,
        user_secret: ENV["CLOUD_ELEMENTS_USER_SECRET"],
        organization_secret: ENV["CLOUD_ELEMENTS_ORGANIZATION_SECRET"]
      )
    end

    def initialize(
      user:,
      user_secret:,
      organization_secret:,
      element_secret: nil
    )
      @user = user
      @user_secret = user_secret
      @organization_secret = organization_secret
      @element_secret = element_secret
    end

    def authorize(element_secret)
      self.class.new(
        user: @user,
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

    def request
      @request ||= Request.new(
        element_secret: @element_secret,
        organization_secret: @organization_secret,
        user_secret: @user_secret
      )
    end
  end
end
