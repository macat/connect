require "rails_helper"

describe Icims::CandidateSearch do
  describe "#all" do
    it "get search results" do
      stub_search_request

      connection = double(
        "icims_connection",
        api_url: icims_customer_api_url,
        key: "MY_KEY",
        username: "USERNAME",
      )

      candidate_search = Icims::CandidateSearch.new(connection: connection)

      expect(candidate_search.all).to eq JSON.parse(search_results)
    end
  end

  def stub_search_request
    stub_request(:post, "#{icims_customer_api_url}/search/people").
      with(headers: { "Authorization" => hexdigest_matcher }).
      to_return(body: search_results)
  end

  def search_results
    {"searchResults" => [{ "id" => 8986 }]}.to_json
  end
end
