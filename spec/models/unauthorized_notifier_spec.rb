require "rails_helper"

describe UnauthorizedNotifier do
  describe "#integration_name" do
    it "translates to a proper name" do
      notifier = UnauthorizedNotifier.new(
        double(:connection, integration_id: :icims)
      )

      expect(notifier.integration_name).to eq("iCIMS")
    end
  end

  describe "#log_and_notify_of_unauthorized_exception" do
    it "logs the exception" do
      connection = build_stubbed(:net_suite_connection)
      notifier = UnauthorizedNotifier.new(connection)
      exception = Unauthorized.new(Unauthorized::DEFAULT_MESSAGE)

      expect(Rails.logger).to receive(:error).with(
        "#{exception.class} error #{exception.message} for " \
        "installation_id: #{connection.installation_id} " \
        "with #{notifier.integration_name}"
      )

      notifier.log_and_notify_of_unauthorized_exception(exception)
    end

    it "tells installation to send_connection_notification" do
      connection = build_stubbed(:net_suite_connection)
      exception = Unauthorized.new(Unauthorized::DEFAULT_MESSAGE)
      allow(connection.installation).to receive(:send_connection_notification)

      UnauthorizedNotifier.new(connection).
        log_and_notify_of_unauthorized_exception(exception)

      expect(connection.installation).to have_received(
        :send_connection_notification
      ).with(
        integration_id: connection.integration_id,
        message: exception.message
      )
    end
  end
end
