require "rails_helper"

describe Icims::Client do
  describe "#recent_hires" do
    context "when the API request is successful" do
      it "fetches recent hires from the iCIMS API" do
        Timecop.freeze do
          stub_request(:post, "#{api_url}/search/people").
            with(headers: { "Authorization" => hexdigest_matcher }).
            to_return(body: search_results)
          stub_request(:get, "#{api_url}/people/8986").
            to_return(
              body: sample_response(
                firstname: "Dade",
                lastname: "Murphy",
                email: "crash.override@example.com",
              ),
              headers: { "Content-Type" => "application/json" },
            )
          connection = double(
            "icims_connection",
            key: "MY_KEY",
            api_url: api_url,
            username: "USERNAME",
          )
          client = described_class.new(connection)

          recent_hires = client.recent_hires

          first_hire = recent_hires.first
          expect(recent_hires.length).to eq 1
          expect(first_hire).to have_attributes(
            email: "crash.override@example.com",
            firstname: "Dade",
            lastname: "Murphy",
          )
        end
      end

      context "when the json response doesn't have candidates" do
        it "returns an empty list of candidates" do
          Timecop.freeze do
            stub_request(:post, "#{api_url}/search/people").
              with(headers: { "Authorization" => hexdigest_matcher }).
              to_return(
                body: '{"searchResults": []}',
                headers: { "Content-Type" => "application/json" },
              )
            connection = double(
              "icims_connection",
              key: "MY_KEY",
              api_url: api_url,
              username: "USERNAME",
            )

            client = described_class.new(connection)

            expect(client.recent_hires).to be_empty
          end
        end
      end
    end

    context "when the API request fails" do
      it "raises an exception" do
        stub_request(:post, "#{api_url}/search/people").
          to_return(
            body: '{"errors":[{"errorMessage":"an error message","errorCode":26}]}',
            headers: { "Content-Type" => "application/json" },
          )

        connection = double(
          "icims_connection",
          key: "MY_KEY",
          api_url: api_url,
          username: "USERNAME",
        )
        client = described_class.new(connection)

        expect { client.recent_hires }.
          to raise_exception(described_class::Error)
      end
    end
  end

  def search_results
    {"searchResults" => [{ "id" => 8986 }]}.to_json
  end

  def sample_response(values = {})
    {
      hiredate: "2013-04-30",
      startdate: "2013-05-03",
      email: "jtiberiusd@example.com",
      lastname: "Doe",
      firstname: "Jane",
      addresses: [
        {
          addresscounty: "New York",
          addresszip: "10001",
          addressstreet1: "123 Abc St",
          entry: 4128,
          addresscity: "New York",
        },
      ],
      phones: [
        phonenumber: "302-555-5555",
      ],
    }.merge(values).to_json
  end

  def hexdigest_matcher
    /[a-f0-9]+/
  end

  def api_url
    "https://api.icims.com/customers/2197"
  end
end
