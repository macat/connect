require "rails_helper"

describe NetSuiteExportJob do
  describe "#perform" do
    it "runs and export and emails the results" do
      all_profiles = double(:all_profiles)
      namely_profiles = double(:namely_profiles, all: all_profiles)
      client = double(NetSuite::Client)
      net_suite_connection = double(NetSuite::Connection, client: client)
      user = double(
        User,
        email: double(:email),
        namely_profiles: namely_profiles,
        net_suite_connection: net_suite_connection
      )
      user_id = double(:user_id)
      results = double(:results)
      export = double(NetSuite::Export, perform: results)
      allow(User).to receive(:find).with(user_id).and_return(user)
      allow(NetSuite::Export).
        to receive(:new).
        with(namely_profiles: all_profiles, net_suite: client).
        and_return(export)
      mail = double(SyncMailer, deliver: true)
      allow(SyncMailer).
        to receive(:net_suite_notification).
        with(email: user.email, results: results).
        and_return(mail)
      job = NetSuiteExportJob.new(user_id)

      job.perform

      expect(export).to have_received(:perform)
      expect(mail).to have_received(:deliver)
    end
  end
end
