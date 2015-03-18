require "rails_helper"

feature "User imports icims people" do
  let(:api_host) do
    "%{protocol}://%{subdomain}.namely.com" % {
      protocol: Rails.configuration.namely_api_protocol,
      subdomain: ENV["TEST_NAMELY_SUBDOMAIN"],
    }
  end

  scenario "successfully imports candidates" do
    stub_person_search
    stub_first_person_results
    stub_second_person_results

    stub_request(:post, "#{ api_host }/api/v1/profiles").
      to_return(status: 200, body: File.read("spec/fixtures/api_responses/not_empty_profiles.json"))

    stub_request(:get, "#{ api_host }/api/v1/profiles").
      with(query: {access_token: ENV["TEST_NAMELY_ACCESS_TOKEN"], limit: "all"}).
      to_return(status: 200, body: File.read("spec/fixtures/api_responses/empty_profiles.json"))

    user = create(:user)
    create(:icims_connection, :connected, user: user, found_namely_field: true)

    visit dashboard_path(as: user)
    within(".icims-account") do
      click_button t("dashboards.show.import_now")
    end

    expect(page).to have_content t("icims_imports.create.imported_successfully")
  end

  def stub_person_search
    stub_request(:post, "https://api.icims.com/customers/2187/search/people").
      to_return(body: File.read("spec/fixtures/api_responses/icims_search_candidates.json"))
  end

  def stub_first_person_results
    stub_request(:get, "https://api.icims.com/customers/2187/people/8986").
      with(query: { fields: required_fields }).
      to_return(
        body: File.read("spec/fixtures/api_responses/first_icims_candidate.json")
      )
  end

  def stub_second_person_results
    stub_request(:get, "https://api.icims.com/customers/2187/people/8988").
      with(query: { fields: required_fields }).
      to_return(
        body: File.read("spec/fixtures/api_responses/second_icims_candidate.json")
      )
  end

  def required_fields
    ["email", "firstname", "gender", "lastname", "startdate"].join(",")
  end
end
