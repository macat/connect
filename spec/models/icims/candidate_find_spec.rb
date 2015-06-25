require "rails_helper"

describe Icims::CandidateFind do
  describe "#find" do
    it "finds the user based on id" do
      id = 8986

      stub_find_request(id)

      connection = double(
        "icims_connection",
        api_url: icims_customer_api_url,
        key: "MY_KEY",
        user: double(User),
        username: "USERNAME",
      )

      candidate_find = described_class.new(connection: connection)

      expect(candidate_find.find(id)).
        to eq(JSON.parse(sample_response(id: id)))
    end
  end

  def sample_response(values = {})
    {
      startdate: "2013-05-03",
      email: "jtiberiusd@example.com",
      lastname: "Doe",
      firstname: "Jane",
      gender: "Female",
    }.merge(values).to_json
  end

  def stub_find_request(id)
    stub_request(:get, "#{icims_customer_api_url}/people/#{id}").
      with(
        query: { fields: required_fields },
        headers: { "Authorization" => hexdigest_matcher },
      ).
      to_return(
        body: sample_response,
        headers: { "Content-Type" => "application/json" },
      )
  end

  def required_fields
    described_class::REQUIRED_FIELDS.join(",")
  end
end
