require "rails_helper"

feature "User visits their dashboard" do
  let(:api_host) do
    "%{protocol}://%{subdomain}.namely.com" % {
      protocol: Rails.configuration.namely_api_protocol,
      subdomain: ENV['TEST_NAMELY_SUBDOMAIN'],
    }
  end
  let(:fixture_file) { "fields_without_jobvite" }
  before do
    stub_request(:get, /.*api\/v1\/profiles\/fields/)
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/#{ fixture_file }.json"))
  end
  context "with a Jobvite connection, but no Jobvite field on Namely" do
    scenario do
      user = create(:user)
      create(
        :jobvite_connection,
        :connected,
        user: user,
        found_namely_field: false,
      )


      visit dashboard_path(as: user)

      expect(page).to have_content t(
        "dashboards.show.missing_namely_field",
        name: "jobvite_id",
      )
    end
  end

  context "with a Jobvite connection, and a Jobvite field on Namely" do
    let(:fixture_file) { "fields_with_jobvite" }
    scenario do
      user = create(:user)
      create(
        :jobvite_connection,
        :connected,
        user: user,
        found_namely_field: true,
      )

      visit dashboard_path(as: user)

      expect(page).not_to have_content t(
        "dashboards.show.missing_namely_field",
        name: "jobvite_id",
      )
    end
  end
end
