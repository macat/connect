require "rails_helper"

describe NetSuite::Connection do
  describe "#connected?" do
    context "with saved authorization data" do
      it "returns true" do
        expect(NetSuite::Connection.new(instance_id: "x", authorization: "y")).
          to be_connected
      end
    end

    context "without authorization data" do
      it "returns false" do
        expect(NetSuite::Connection.new(instance_id: nil, authorization: "y")).
          not_to be_connected
        expect(NetSuite::Connection.new(instance_id: "x", authorization: nil)).
          not_to be_connected
      end
    end
  end

  describe "#enabled?" do
    context "with Cloud Elements configuration" do
      it "returns true" do
        ClimateControl.modify CLOUD_ELEMENTS_ORGANIZATION_SECRET: "abc" do
          expect(NetSuite::Connection.new).to be_enabled
        end
      end
    end

    context "without Cloud Elements configuration" do
      it "returns false" do
        ClimateControl.modify CLOUD_ELEMENTS_ORGANIZATION_SECRET: nil do
          expect(NetSuite::Connection.new).not_to be_enabled
        end
      end
    end
  end

  describe "#client" do
    it "configures a client with its authorization" do
      authorized_client = double(:authorized_client)
      client_from_env = double(:client_from_env)
      allow(NetSuite::Client).to receive(:from_env).and_return(client_from_env)
      allow(client_from_env).
        to receive(:authorize).
        with("x").
        and_return(authorized_client)
      connection = NetSuite::Connection.new(authorization: "x")

      result = connection.client

      expect(result).to eq(authorized_client)
    end
  end

  describe "#disconnect" do
    it "clears connected fields" do
      connection = create(:net_suite_connection, :connected)

      connection.disconnect

      expect(connection.reload).not_to be_connected
    end
  end
end
