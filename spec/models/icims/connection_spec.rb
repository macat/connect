require "rails_helper"

describe Icims::Connection do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "#connected?" do
    it "returns true when the username and password are set" do
      icims_connection = described_class.new(
        customer_id: 1,
        key: "some key",
        username: "username",
      )

      expect(icims_connection).to be_connected
    end

    it "returns false when the username or password is missing" do
      expect(described_class.new).not_to be_connected
      expect(described_class.new(username: "username")).not_to be_connected
      expect(described_class.new(customer_id: 1)).not_to be_connected
      expect(described_class.new(key: "key")).not_to be_connected
    end
  end

  describe "#disconnect" do
    it "sets the username,key and customer_id to nil" do
      icims_connection = create(
        :icims_connection,
        username: "crashoverride",
      )

      icims_connection.disconnect

      expect(icims_connection.customer_id).to be_nil
      expect(icims_connection.key).to be_nil
      expect(icims_connection.username).to be_nil
    end
  end

  describe "#missing_namely_field?" do
    it "doesn't check when not connected" do
      icims_connection = described_class.new
      allow(icims_connection).to receive(:check_namely_field)

      icims_connection.missing_namely_field?

      expect(icims_connection).not_to have_received(:check_namely_field)
    end

    it "checks and caches required namely field status" do
      icims_connection = create(
        :icims_connection,
        :connected,
        found_namely_field: false,
      )
      icims_field = double("icims_field", name: "icims_id")
      allow(icims_connection).
        to receive_message_chain(:namely_connection, :fields, :all) {
        [icims_field]
      }

      expect(icims_connection).not_to be_missing_namely_field
      expect(icims_connection).to be_found_namely_field
    end
  end
end
