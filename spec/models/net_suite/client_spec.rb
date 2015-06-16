require "rails_helper"

describe NetSuite::Client do
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
          user_secret: "x",
          organization_secret: "x"
        )

        result = client.create_instance({})

        expect(result).not_to be_success
        expect(result[:message]).to eq(error)
      end
    end
  end
end
