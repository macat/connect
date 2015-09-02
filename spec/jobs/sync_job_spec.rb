require "rails_helper"

describe SyncJob do
  describe "#perform" do
    it "runs and export and emails the results" do
      results = double(:results)
      net_suite_connection = double(NetSuite::Connection, sync: results)
      installation = double(
        Installation,
        net_suite_connection: net_suite_connection,
      )
      installation_id = double(:installation_id)
      allow(SyncNotifier).to receive(:deliver)
      allow(Installation).
        to receive(:find).
        with(installation_id).
        and_return(installation)
      integration_id = "net_suite"
      job = SyncJob.new(integration_id, installation_id)

      job.perform

      expect(net_suite_connection).to have_received(:sync)
      expect(SyncNotifier).
        to have_received(:deliver).
        with(
          results: results,
          integration_id: integration_id,
          installation: installation
        )
    end
  end

  context "authentication failure" do
    it "traps exception and alerts the user" do
      net_suite_connection = double(NetSuite::Connection)
      installation = double(
        Installation,
        id: 1,
        net_suite_connection: net_suite_connection,
      )
      installation_id = double(:installation_id)
      exception = Unauthorized.new("An error message")
      allow(net_suite_connection).to receive(:sync).
        and_raise(exception)
      integration_id = "net_suite"
      allow(Installation).
        to receive(:find).
        with(installation_id).
        and_return(installation)
      allow(installation).to receive(:send_connection_notification).with(
        integration_id: integration_id,
        message: exception.message
      )
      job = SyncJob.new(integration_id, installation_id)

      expect(Rails.logger).to receive(:error).with(
        "Unauthorized error An error message for installation_id: " \
        "#{installation.id} with NetSuite"
      )

      job.perform

      expect(installation).to have_received(:send_connection_notification).
        with(integration_id: integration_id, message: exception.message)
    end
  end
end
