require "rails_helper"

describe Greenhouse::AttributeMapper do
  describe "#call" do
    it "transforms a Greenhouse candidate into a Hash appropriate for the Namely API" do
      mapper = described_class.new
      greenhouse_candidate = JSON.parse(
        File.read('spec/fixtures/api_requests/greenhouse_payload.json'))['payload']

      expect(mapper.call(greenhouse_candidate)).to eq(
        first_name: "Johnny",
        last_name: "Smith",
        email: "personal@example.com",
        user_status: "active",
        start_date: "2015-01-23",
        home: "455 Broadway New York, NY 10280",
        greenhouse_id: "20",
      )
    end
  end

  describe "#namely_identifier_field" do
    it "returns the custom Namely profile field that stores the Greenhouse ID" do
      mapper = described_class.new

      expect(mapper.namely_identifier_field).to eq :greenhouse_id
    end
  end
end
