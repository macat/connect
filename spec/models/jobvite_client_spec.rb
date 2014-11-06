require "rails_helper"

describe JobviteClient do
  describe "#recent_hires" do
    context "when the API request is successful" do
      it "fetches recent hires from the Jobvite API" do
        stub_request(:get, "https://api.jobvite.com/api/v2/candidate").
          with(query: hash_including("api" => "MY_API_KEY", "sc" => "MY_SECRET")).
          to_return(
            body: sample_response,
            headers: { "Content-Type" => "application/json" },
          )
        connection = double(
          "JobviteConnection",
          api_key: "MY_API_KEY",
          secret: "MY_SECRET",
        )
        client = described_class.new(connection)

        recent_hires = client.recent_hires

        first_hire = recent_hires.first
        expect(recent_hires.length).to eq 1
        expect(first_hire.first_name).to eq "Dade"
        expect(first_hire.last_name).to eq "Murphy"
        expect(first_hire.email).to eq "crash.override@example.com"
      end
    end

    context "when the API request fails" do
      it "raises an exception" do
        stub_request(:get, "https://api.jobvite.com/api/v2/candidate").
          with(query: hash_including("api" => "MY_API_KEY", "sc" => "MY_SECRET")).
          to_return(
            body: '{"errors":{"code":400,"messages":["an error message"]}}',
            headers: { "Content-Type" => "application/json" },
          )
        connection = double(
          "JobviteConnection",
          api_key: "MY_API_KEY",
          secret: "MY_SECRET",
        )
        client = described_class.new(connection)

        expect { client.recent_hires }.
          to raise_exception(described_class::Error)
      end
    end
  end

  def sample_response
    <<-JSON
{
  "candidates": [
    {
      "address": "",
      "address2": "",
      "application": {
        "comments": null,
        "customField": [],
        "disposition": null,
        "eId": "pN0gfhw4",
        "gender": "Undefined",
        "hireDate": 1415088000000,
        "job": {
          "company": null,
          "customField": null,
          "department": null,
          "eId": null,
          "hiringManagers": null,
          "location": null,
          "recruiters": null,
          "requisitionId": null,
          "subsidiaryId": null,
          "title": null
        },
        "lastUpdatedDate": 1415088000000,
        "race": "Decline to Self Identify",
        "source": "Eugene Belford",
        "sourceType": "Recruiter",
        "startDate": 1415865600000,
        "status": null,
        "veteranStatus": "Undefined"
      },
      "city": "",
      "companyName": "",
      "country": "",
      "eId": "edO1Ggwt",
      "email": "crash.override@example.com",
      "firstName": "Dade",
      "homePhone": "",
      "lastName": "Murphy",
      "location": ",  ",
      "postalCode": null,
      "state": "",
      "title": "",
      "workPhone": "",
      "workStatus": "None"
    }
  ],
  "total": 1
}
    JSON
  end
end
