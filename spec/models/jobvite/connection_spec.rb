require "rails_helper"

describe Jobvite::Connection do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:hired_workflow_state) }
  end

  describe "#connected?" do
    it "returns true when the api_key and secret are set" do
      jobvite_connection = described_class.new(api_key: "a", secret: "b")

      expect(jobvite_connection).to be_connected
    end

    it "returns false when the api_key or secret is missing" do
      expect(described_class.new).not_to be_connected
      expect(described_class.new(api_key: "a")).not_to be_connected
      expect(described_class.new(secret: "b")).not_to be_connected
    end
  end

  describe "#disconnect" do
    it "sets the api_key and secret to nil" do
      jobvite_connection = create(
        :jobvite_connection,
        api_key: "a",
        secret: "b"
      )

      jobvite_connection.disconnect

      expect(jobvite_connection.api_key).to be_nil
      expect(jobvite_connection.secret).to be_nil
    end
  end
end
