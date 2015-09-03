require "rails_helper"

describe UnauthorizedNotifier do
  describe ".deliver" do
    it "records a sync summary" do
      connection = create(:net_suite_connection)
      exception = double(:exception, message: "failed")

      UnauthorizedNotifier.deliver(
        connection: connection,
        exception: exception
      )
      summary = SyncSummary.find_by(
        connection: connection,
        authorization_error: exception.message
      )

      expect(summary).to be_present
    end

    it "tells installation to send_connection_notification" do
      connection = build_stubbed(:net_suite_connection)
      exception = Unauthorized.new(Unauthorized::DEFAULT_MESSAGE)
      allow(connection.installation).to receive(:send_connection_notification)
      allow(SyncSummary).to receive(:create!)

      UnauthorizedNotifier.deliver(
        connection: connection,
        exception: exception
      )

      expect(connection.installation).to have_received(
        :send_connection_notification
      ).with(
        integration_id: connection.integration_id,
        message: exception.message
      )
    end
  end
end
