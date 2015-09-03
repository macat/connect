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
      allow(connection).to receive(:sync).and_raise(exception)
      allow(UnauthorizedNotifier).to receive(:deliver)

      SyncJob.perform_now(connection)

      expect(UnauthorizedNotifier).to have_received(:deliver).
        with(connection: connection, exception: exception)
    end
  end
end
