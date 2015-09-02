require "rails_helper"

describe SyncNotifier do
  describe ".deliver" do
    it "sends an email to each user on the installation" do
      user = build_stubbed(:user)
      connection = double(:connection)
      installation = build_stubbed(:installation, users: [user])
      integration_id = double(:integration_id)
      allow(installation).
        to receive(:connection_to).
        with(integration_id).
        and_return(connection)
      results = double(:results)
      mail = double(SyncMailer, deliver_now: true)
      allow(SyncSummary).
        to receive(:create_from_results!)
      allow(SyncMailer).
        to receive(:sync_notification).
        and_return(mail)

      SyncNotifier.deliver(
        installation: installation,
        integration_id: integration_id,
        results: results,
      )

      expect(SyncMailer).to have_received(:sync_notification).
        with(
          email: user.email,
          integration_id: integration_id,
          results: results
        )
      expect(mail).to have_received(:deliver_now)
      expect(SyncSummary).to have_received(:create_from_results!).with(
        connection: connection,
        results: results
      )
    end
  end
end
