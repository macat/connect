require "rails_helper"

feature "User visits their dashboard" do
  let(:api_host) do
    "%{protocol}://%{subdomain}.namely.com" % {
      protocol: Rails.configuration.namely_api_protocol,
      subdomain: ENV['TEST_NAMELY_SUBDOMAIN'],
    }
  end

  context "with a Jobvite connection, but no Jobvite field on Namely" do
    scenario do
      stub_namely_request("fields_without_jobvite")
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
    scenario do
      stub_namely_request("fields_with_jobvite")
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

  context "with a iCIMS connection, but no iCIMS field on Namely" do
    scenario do
      stub_namely_request("fields_without_icims")
      user = create(:user)
      create(
        :icims_connection,
        :connected,
        user: user,
        found_namely_field: false,
      )


      visit dashboard_path(as: user)

      expect(page).to have_content t(
        "dashboards.show.missing_namely_field",
        name: "icims_id",
      )
    end
  end

  context "with a iCIMS connection, and a iCIMS field on Namely" do
    scenario do
      stub_namely_request("fields_with_icims")
      user = create(:user)
      create(
        :icims_connection,
        :connected,
        user: user,
        found_namely_field: true,
      )

      visit dashboard_path(as: user)

      expect(page).not_to have_content t(
        "dashboards.show.missing_namely_field",
        name: "icims_id",
      )
    end
  end

  def stub_namely_request(fixture_file)
    stub_request(:get, /.*api\/v1\/profiles\/fields/)
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/#{ fixture_file }.json"))
  end
end
