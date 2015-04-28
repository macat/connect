require "rails_helper"

describe Greenhouse::AttributeMapper do
  describe "#call" do
    it "transforms a Greenhouse candidate into a Hash appropriate for the Namely API" do
      mapper = described_class.new
      greenhouse_candidate = double(
        "greenhouse_candidate",
        application: double(:application, id: -1),
        candidate: double(:candidate, 
                          first_name: "Dade",
                          last_name: "Murphy",
                          email_addresses: [
                            double(:email_address, 
                                   value: "crash.override@example.com",
                                   type: "personal")
                          ], 
                          addresses: [
                            double(:address,
                                  value: "455 Broadway New York, NY 10280",
                                  type: "home")
                          ]
                         ),
        offer: double(:offer, starts_at: "2014-01-02"),
      )

      expect(mapper.call(greenhouse_candidate)).to eq(
        first_name: "Dade",
        last_name: "Murphy",
        email: "crash.override@example.com",
        user_status: "active",
        start_date: "2014-01-02",
        home: "455 Broadway New York, NY 10280",
        greenhouse_id: "-1",
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
