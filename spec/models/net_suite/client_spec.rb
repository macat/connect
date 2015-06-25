require "rails_helper"

describe NetSuite::Client do
  describe ".from_env" do
    it "finds authorization from the environment" do
      env = {
        "CLOUD_ELEMENTS_USER_SECRET" => "user-secret",
        "CLOUD_ELEMENTS_ORGANIZATION_SECRET" => "org-secret"
      }

      ClimateControl.modify env do
        stub_request(:post, /.*/)
        client = NetSuite::Client.from_env(build_stubbed(:user))

        client.create_instance({})

        expect(WebMock).to have_requested(:post, /.*/).with(
          headers: {
            "Authorization" => "User user-secret, Organization org-secret"
          }
        )
      end
    end
  end

  describe "#authorize" do
    it "sets element authorization" do
      stub_request(:post, /.*/)
      client = NetSuite::Client.new(
        user: build_stubbed(:user),
        user_secret: "user-secret",
        organization_secret: "org-secret",
      )

      client.
        authorize("element-secret").
        create_instance({})

      expect(WebMock).to have_requested(:post, /.*/).with(
        headers: {
          "Authorization" => "User user-secret, " \
            "Organization org-secret, " \
            "Element element-secret"
        }
      )
    end
  end

  describe "#create_instance" do
    context "on HTTP success" do
      it "returns successful data" do
        instance = { "id" => "123", "token" => "abcxyz" }
        stub_request(
          :post,
          "https://api.cloud-elements.com/elements/api-v2/instances"
        ).
          with(
            body: {
              configuration: {
                "user.username" => "u@example.com",
                "user.password" => "secret",
                "netsuite.accountId" => "123",
                "netsuite.sandbox" => false
              },
              "element" => {
                "key" => "netsuiteerp"
              },
              "tags" => [],
              "name" => "123_netsuite"
            }.to_json,
            headers: {
              "Authorization" => "User user-secret, Organization org-secret",
              "Content-Type" => "application/json"
            }
          ).
          to_return(status: 200, body: instance.to_json)

        client = NetSuite::Client.new(
          user: build_stubbed(:user),
          user_secret: "user-secret",
          organization_secret: "org-secret"
        )

        result = client.create_instance(
          email: "u@example.com",
          password: "secret",
          account_id: "123"
        )

        expect(result).to be_success
        expect(result[:id]).to eq("123")
        expect(result[:token]).to eq("abcxyz")
      end
    end

    context "on HTTP failure" do
      it "returns failure messages" do
        error = "a failure"
        stub_request(
          :post,
          "https://api.cloud-elements.com/elements/api-v2/instances"
        ).
          to_return(status: 400, body: { message: error }.to_json)

        client = NetSuite::Client.new(
          user: build_stubbed(:user),
          user_secret: "x",
          organization_secret: "x"
        )

        result = client.create_instance({})

        expect(result).not_to be_success
        expect(result[:message]).to eq(error)
      end
    end

    context "on authentication failure" do
      it "sends an invalid authentication message" do
        error = "Invalid Organization or User secret, or invalid Element" \
                " token provided."

        stub_request(
          :post,
          "https://api.cloud-elements.com/elements/api-v2/instances"
        ).
          to_return(status: 401, body: { message: error }.to_json)

        user = build_stubbed(:user)

        client = NetSuite::Client.new(
          user: user,
          user_secret: "x",
          organization_secret: "x"
        )

        mail = double(ConnectionMailer, deliver: true)
        allow(ConnectionMailer).
          to receive(:authentication_notification).
          with(email: user.email, connection_type: "net_suite").
          and_return(mail)

        expect { client.create_instance({}) }.to raise_error(
          NetSuite::Client::Unauthorized
        )
        expect(mail).to have_received(:deliver)
      end
    end
  end

  describe "#create_employee" do
    context "on HTTP success" do
      it "returns successful data" do
        employee = { internalId: "1949" }
        stub_request(
          :post,
          "https://api.cloud-elements.com/elements/api-v2/hubs/erp/employees"
        ).
          with(
            body: {
              firstName: "Sally",
              lastName: "Sitwell",
              email: "sally@example.com",
              gender: "_female",
              phone: "123-123-1234",
              subsidiary: { internalId: 1 },
              title: "CEO"
            }.to_json,
            headers: {
              "Authorization" => "User user-secret, " \
                "Organization org-secret, " \
                "Element element-secret",
              "Content-Type" => "application/json"
            }
          ).
          to_return(status: 200, body: employee.to_json)

        client = NetSuite::Client.new(
          user: build_stubbed(:user),
          user_secret: "user-secret",
          organization_secret: "org-secret",
          element_secret: "element-secret"
        )

        result = client.create_employee(
          firstName: "Sally",
          lastName: "Sitwell",
          email: "sally@example.com",
          gender: "_female",
          phone: "123-123-1234",
          subsidiary: { internalId: 1 },
          title: "CEO"
        )

        expect(result).to be_success
        expect(result["internalId"]).to eq("1949")
      end
    end
  end

  describe "#update_employee" do
    context "on HTTP success" do
      it "returns successful data" do
        employee = { internalId: "1949" }
        stub_request(
          :patch,
          "https://api.cloud-elements.com/elements/api-v2" \
          "/hubs/erp/employees/1949"
        ).
          with(
            body: {
              firstName: "Sally",
              lastName: "Sitwell",
              email: "sally@example.com",
              gender: "_female",
              phone: "123-123-1234",
              subsidiary: { internalId: 1 },
              title: "CEO"
            }.to_json,
            headers: {
              "Authorization" => "User user-secret, " \
                "Organization org-secret, " \
                "Element element-secret",
              "Content-Type" => "application/json"
            }
          ).
          to_return(status: 200, body: employee.to_json)

        client = NetSuite::Client.new(
          user: build_stubbed(:user),
          user_secret: "user-secret",
          organization_secret: "org-secret",
          element_secret: "element-secret"
        )

        result = client.update_employee(
          employee[:internalId],
          firstName: "Sally",
          lastName: "Sitwell",
          email: "sally@example.com",
          gender: "_female",
          phone: "123-123-1234",
          subsidiary: { internalId: 1 },
          title: "CEO",
        )

        expect(result).to be_success
        expect(result["internalId"]).to eq("1949")
      end
    end
  end

  describe "#subsidiaries" do
    it "looks up subsidiaries" do
      subsidiaries = [
        { "internalId" => "1", "name" => "Apple" },
        { "internalId" => "2", "name" => "Banana" }
      ]
      stub_request(
        :get,
        "https://api.cloud-elements.com/elements/api-v2" \
        "/hubs/erp/lookups/subsidiary"
      ).
        with(
          headers: {
            "Authorization" => "User user-secret, " \
            "Organization org-secret, " \
            "Element element-secret",
            "Content-Type" => "application/json"
          }
        ).
        to_return(status: 200, body: subsidiaries.to_json)

      client = NetSuite::Client.new(
        user: build_stubbed(:user),
        user_secret: "user-secret",
        organization_secret: "org-secret",
        element_secret: "element-secret"
      )

      result = client.subsidiaries

      expect(result).to be_success
      expect(result.to_a).to eq(subsidiaries)
    end
  end
end
