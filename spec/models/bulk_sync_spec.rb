require "rails_helper"

describe BulkSync do
  include Features

  describe "#sync" do
    context "with a fully connected user" do
      it "creates an sync job for every user with the given connection" do
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

        queue_sync user

        expect(WebMock).not_to have_synced_a_profile

        run_queue

        expect(WebMock).to have_synced_a_profile.twice
      end
    end

    context "with a user without a mapped Namely field" do
      it "doesn't sync" do
        user = create(:user)
        create(
          :net_suite_connection,
          :connected,
          found_namely_field: false,
          user: user
        )

        queue_sync user
        run_queue

        expect(WebMock).not_to have_synced_a_profile
      end
    end

    context "with a disconnected user" do
      it "doesn't sync" do
        user = create(:user)

        queue_sync user
        run_queue

        expect(WebMock).not_to have_synced_a_profile
      end
    end

    def queue_sync(*users)
      BulkSync.new(
        integration_id: :net_suite,
        users: User.where(id: users)
      ).sync
    end

    def run_queue
      Delayed::Worker.new.work_off
    end

    def have_synced_a_profile
      have_requested(
        :post,
        "https://api.cloud-elements.com/elements/api-v2/hubs/erp/employees"
      )
    end
  end
end
