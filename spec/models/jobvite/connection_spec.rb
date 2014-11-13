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

  describe "#missing_namely_field?" do
    context "when the connection is not connected to Jobvite" do
      it "returns false" do
        connection = create(
          :jobvite_connection,
          :disconnected,
          found_namely_field: false,
        )

        expect(connection).not_to be_missing_namely_field
      end
    end

    context "when the field hasn't previously been found and does not exist" do
      it "returns true" do
        connection = create(
          :jobvite_connection,
          :connected,
          found_namely_field: false,
        )
        stub_namely_connection(connection.user, field_names: [])

        expect(connection).to be_missing_namely_field
        expect(connection.reload.found_namely_field).to eq false
      end
    end

    context "when the field hasn't previously been found but does exist" do
      it "returns false and updates the connection" do
        connection = create(
          :jobvite_connection,
          :connected,
          found_namely_field: false,
        )
        stub_namely_connection(connection.user, field_names: ["jobvite_id"])

        expect(connection).not_to be_missing_namely_field
        expect(connection.reload.found_namely_field).to eq true
      end
    end

    context "when the field has previously been found" do
      it "returns false without hitting the Namely API" do
        connection = create(
          :jobvite_connection,
          :connected,
          found_namely_field: true,
        )
        stub_namely_connection(connection.user, field_names: ["jobvite_id"])

        expect(connection).not_to be_missing_namely_field
        expect(connection.user).not_to have_received(:namely_connection)
      end
    end
  end

  def stub_namely_connection(user, field_names:)
    fields = field_names.map { |name| double("field", name: name) }
    fields_collection = double("fields", all: fields)
    namely_connection = double("namely_connection", fields: fields_collection)
    allow(user).to receive(:namely_connection).and_return(namely_connection)
  end
end
