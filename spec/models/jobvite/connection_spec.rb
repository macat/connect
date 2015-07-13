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
        secret: "b",
      )

      jobvite_connection.disconnect

      expect(jobvite_connection.api_key).to be_nil
      expect(jobvite_connection.secret).to be_nil
    end
  end

  describe "#sync" do
    it "uses the importer" do
      jobvite_connection = create(:jobvite_connection)
      candidate = double("candidate")
      failure = double("failed_candidate_import", success?: false)
      success = double("successful_candidate_import", success?: true)
      results_hash = [{ result: success, candidate: candidate },
                      { result: failure, candidate: candidate }]
      importer = double("importer", import: results_hash)
      allow(Importer).to receive(:new).and_return(importer)

      results = jobvite_connection.sync

      expect(importer).to have_received(:import)
      expect(results[0]).to be_success
      expect(results[1]).not_to be_success
    end
  end

  def stub_namely_connection(user, field_names:)
    fields = field_names.map { |name| double("field", name: name) }
    fields_collection = double("fields", all: fields)
    namely_connection = double("namely_connection", fields: fields_collection)
    allow(user).to receive(:namely_connection).and_return(namely_connection)
  end
end
