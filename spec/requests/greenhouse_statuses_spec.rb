require "rails_helper"

describe "Greenhouse new candidate" do
  let(:api_host) do
    "%{protocol}://%{subdomain}.namely.com" % {
      protocol: Rails.configuration.namely_api_protocol,
      subdomain: ENV["TEST_NAMELY_SUBDOMAIN"],
    }
  end
  let(:connection) do 
    create(:greenhouse_connection, :with_namely_field, name: "myhook") 
  end

  it 'authorize request comming from greenhouse with valid digest' do 
    allow_any_instance_of(Greenhouse::ValidRequesterPolicy).to receive(:valid?) { true }
    post greenhouse_candidate_imports_url(connection.secret_key), {greenhouse_candidate_import: greenhouse_ping}, {"Signature" => "sha256 kdkjadk92929394ajdskfjadf"}
      
    expect(response.body).to be_blank
    expect(response.status).to eql 200
  end

  it 'unauthorize request not comming from greenhouse with valid digest' do 
    allow_any_instance_of(Greenhouse::ValidRequesterPolicy).to receive(:valid?) { false }
    post greenhouse_candidate_imports_url(connection.secret_key), {greenhouse_candidate_import: greenhouse_ping}, {"Signature" => "sha256 kdkjadk92929394ajdskfjadf"}
      
    expect(response.body).to be_blank
    expect(response.status).to eql 401
  end

  it "creates new user in namely" do
    stub_request(:post, "#{api_host}/api/v1/profiles").
      to_return(
        status: 200,
        body: File.read("spec/fixtures/api_responses/not_empty_profiles.json"),
      )

    post greenhouse_candidate_imports_url(connection.secret_key), greenhouse_candidate_import: greenhouse_payload

    expect(response.body).to be_blank
    expect(response.status).to eq 200
    expect(sent_email.subject).
      to eq(t("greenhouse_candidate_import_mailer.successful_import.subject", name: candidate_name))
  end

  def greenhouse_ping
    @greenhouse_ping ||= JSON.parse(
      File.read('spec/fixtures/api_requests/greenhouse_payload_ping.json'))
  end

  def sent_email
    @sent_email ||= ActionMailer::Base.deliveries.first
  end

  def greenhouse_payload 
    @greenhouse_payload ||= JSON.parse(
      File.read("spec/fixtures/api_requests/greenhouse_payload.json")
    )
  end

  def candidate_name
    "Johnny Smith"
  end
end
