require "rails_helper"

describe SyncJob do
  describe "#perform" do
    it "runs an export and emails the results" do
      connection = build_stubbed(:net_suite_connection)
      results = double(:results)
      allow(connection).to receive(:sync).and_return(results)
      allow(SyncNotifier).to receive(:deliver)

      SyncJob.perform_now(connection)

      expect(connection).to have_received(:sync)
      expect(SyncNotifier).
        to have_received(:deliver).
        with(
          results: results,
          integration_id: connection.integration_id,
          installation: connection.installation
        )
    end
  end

  context "authentication failure" do
    it "traps exception and alerts the user" do
      connection = build_stubbed(:net_suite_connection)
      exception = Unauthorized.new("An error message")
      installation = connection.installation
      allow(connection).to receive(:sync).and_raise(exception)
      allow(installation).to receive(:send_connection_notification)
      allow(Rails.logger).to receive(:error)

      SyncJob.perform_now(connection)

      expect(Rails.logger).to have_received(:error).with(/Unauthorized error/)
      expect(installation).to have_received(:send_connection_notification).with(
        integration_id: connection.integration_id,
        message: exception.message
      )
    end
  end
end
