require "rails_helper"

describe "iCIMS new candidate" do
  let(:api_host) do
    "%{protocol}://%{subdomain}.namely.com" % {
      protocol: Rails.configuration.namely_api_protocol,
      subdomain: ENV["TEST_NAMELY_SUBDOMAIN"],
    }
  end

  it "creates new user in namely" do
    stub_person_results
    connection = user_with_icims_connection

    stub_request(:post, "#{api_host}/api/v1/profiles").
      to_return(
        status: 200,
        body: File.read("spec/fixtures/api_responses/not_empty_profiles.json"),
      )

    post icims_candidate_imports_url(connection.api_key), import_data

    expect(response.body).to be_blank
    expect(response.status).to eq 200
    expect(sent_email.subject).
      to eq(t("icims_candidate_import_mailer.successful_import.subject", name: candidate_name))
  end

  it "fails to create a new user in namely" do
    stub_incomplete_person_results
    connection = user_with_icims_connection

    post icims_candidate_imports_url(connection.api_key), import_data

    expect(response.body).to be_blank
    expect(response.status).to eq 200
    expect(sent_email.subject).
      to eq(t("icims_candidate_import_mailer.unsuccessful_import.subject", name: candidate_name))
    expect(sent_email.body).
      to include(icims_candidate_retry_import_url(9166))
  end

  def stub_person_results
    stub_request(:get, "https://api.icims.com/customers/2187/people/9166").
      with(query: { fields: required_fields }).
      to_return(
        body: File.read("spec/fixtures/api_responses/first_icims_candidate.json")
      )
  end

  def user_with_icims_connection
    user = create(:user)
    create(
      :icims_connection,
      :with_namely_field,
      key: "KEY",
      customer_id: 2187,
      user: user,
      username: "USERNAME",
    )
  end

  def required_fields
    Icims::CandidateFind::REQUIRED_FIELDS.join(",")
  end

  def sent_email
    @sent_email ||= ActionMailer::Base.deliveries.first
  end

  def import_data
    @import_data ||= JSON.parse(
      File.read("spec/fixtures/api_requests/icims_status_change.json")
    )
  end

  def stub_incomplete_person_results
    stub_request(:get, "https://api.icims.com/customers/2187/people/9166").
      with(query: { fields: required_fields }).
      to_return(
        body: File.read("spec/fixtures/api_responses/incomplete_icims_candidate.json")
      )
  end

  def candidate_name
    "Jane Doe"
  end
end
