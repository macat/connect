require "rails_helper"

describe SyncJob do
  describe "#perform" do
    it "runs and export and emails the results" do
      results = double(:results)
      net_suite_connection = double(NetSuite::Connection, sync: results)
      user = double(
        User,
        email: double(:email),
        net_suite_connection: net_suite_connection
      )
      user_id = double(:user_id)
      allow(User).to receive(:find).with(user_id).and_return(user)
      integration_id = "net_suite"
      mail = double(SyncMailer, deliver: true)
      allow(SyncMailer).
        to receive(:sync_notification).
        with(
          email: user.email,
          integration_id: integration_id,
          results: results
        ).
        and_return(mail)
      job = SyncJob.new(integration_id, user_id)

      job.perform

      expect(net_suite_connection).to have_received(:sync)
      expect(mail).to have_received(:deliver)
    end
  end
end
