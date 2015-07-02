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

  context "authentication failure" do
    it "traps exception and alerts the user" do
      net_suite_connection = double(NetSuite::Connection)
      user = double(
        User,
        id: 1,
        email: double(:email),
        net_suite_connection: net_suite_connection
      )
      user_id = double(:user_id)
      exception = Unauthorized.new("An error message")
      allow(net_suite_connection).to receive(:sync).
        and_raise(exception)
      integration_id = "net_suite"
      allow(User).to receive(:find).with(user_id).and_return(user)
      allow(user).to receive(:send_connection_notification).with(
        integration_id: integration_id,
        message: exception.message
      )
      job = SyncJob.new(integration_id, user_id)

      expect(SyncMailer).not_to receive(:net_suite_notification)
      expect(Rails.logger).to receive(:error).with(
        "Unauthorized error An error message for user_id: #{user.id} " \
        "with NetSuite"
      )

      job.perform

      expect(user).to have_received(:send_connection_notification).
        with(integration_id: integration_id, message: exception.message)
    end
  end
end
