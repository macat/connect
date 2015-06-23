require "rails_helper"

describe NetSuite::BulkExport do
  include Features

  describe "#export" do
    context "with a fully connected user" do
      it "creates an export for every user with a NetSuite connection" do
        user = create(:user)
        create(
          :net_suite_connection,
          :connected,
          :with_namely_field,
          user: user
        )
        stub_namely_data("/profiles", "profiles_with_net_suite_fields")
        stub_request(:put, %r{.*api/v1/profiles/.*}).to_return(status: 200)
        stub_request(:any, %r{.*/api-v2/hubs/erp/employees.*}).
          to_return(status: 200, body: { "internalId" => "123" }.to_json)

        export user

        expect(WebMock).to have_requested(
          :post,
          "https://api.cloud-elements.com/elements/api-v2/hubs/erp/employees"
        ).twice
      end
    end

    context "with a user without a mapped Namely field" do
      it "doesn't export" do
        user = create(:user)
        create(
          :net_suite_connection,
          :connected,
          found_namely_field: false,
          user: user
        )

        export user

        expect(WebMock).not_to have_requested(:post, %r{.*})
      end
    end

    context "with a disconnected user" do
      it "doesn't export" do
        user = create(:user)

        export user

        expect(WebMock).not_to have_requested(:post, %r{.*})
      end
    end

    def export(*users)
      NetSuite::BulkExport.new(User.where(id: users)).export
    end
  end
end
