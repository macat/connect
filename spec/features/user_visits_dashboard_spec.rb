require "rails_helper"

feature "User visits their dashboard" do
  let(:api_host) do
    "%{protocol}://%{subdomain}.namely.com" % {
      protocol: Rails.configuration.namely_api_protocol,
      subdomain: ENV['TEST_NAMELY_SUBDOMAIN'],
    }
  end

  scenario "user can sign out after" do 
    stub_namely_request("fields_without_jobvite")
    user = create(:user)
    create(
      :jobvite_connection,
      :connected,
      user: user,
      found_namely_field: false,
    )

    visit dashboard_path(as: user)

    click_link t("dashboards.show.sign_out")
    expect(page.current_path).to eql root_path
  end

  context "with a Jobvite connection, but no Jobvite field on Namely" do
    scenario "user is told that the Jobvite field is missing and isn't shown an import button" do
      stub_namely_request("fields_without_jobvite")
      user = create(:user)
      create(
        :jobvite_connection,
        :connected,
        user: user,
        found_namely_field: false,
      )


      visit dashboard_path(as: user)

      within(".jobvite-account") do
        expect(page).to have_content t(
          "dashboards.show.missing_namely_field",
          name: "jobvite_id",
        )
        expect(page).to have_no_button t("dashboards.show.import_now")
      end
    end
  end

  context "with a Jobvite connection, and a Jobvite field on Namely" do
    scenario "user can click an import button" do
      stub_namely_request("fields_with_jobvite")
      user = create(:user)
      create(
        :jobvite_connection,
        :connected,
        user: user,
        found_namely_field: true,
      )

      visit dashboard_path(as: user)

      within(".jobvite-account") do
        expect(page).not_to have_content t(
          "dashboards.show.missing_namely_field",
          name: "jobvite_id",
        )
        expect(page).to have_button t("dashboards.show.import_now")
      end
    end
  end

  context "with a iCIMS connection, but no iCIMS field on Namely" do
    scenario "user is told that the iCIMS field is missing and isn't shown an import button" do
      stub_namely_request("fields_without_icims")
      user = create(:user)
      create(
        :icims_connection,
        :connected,
        user: user,
        found_namely_field: false,
      )

      visit dashboard_path(as: user)

      within(".icims-account") do
        expect(page).to have_content t(
          "dashboards.show.missing_namely_field",
          name: "icims_id",
        )
        expect(page).to have_no_button t("dashboards.show.import_now")
      end
    end
  end

  context "with a iCIMS connection, and a iCIMS field on Namely" do
    scenario "user can click an import button" do
      allow(SecureRandom).to receive(:hex).and_return("api_key")
      stub_namely_request("fields_with_icims")
      user = create(:user)
      connection = create(
        :icims_connection,
        :connected,
        user: user,
        found_namely_field: true,
      )

      visit dashboard_path(as: user)

      within(".icims-account") do
        expect(page).not_to have_content t(
          "dashboards.show.missing_namely_field",
          name: "icims_id",
        )
        expect(page).
          to have_content(icims_candidate_imports_url(connection.api_key))
      end
    end
  end

  context "with a Greenhouse connection, but no Greenhouse field on Namely" do
    scenario "user is told that the Greenhouse field is missing and isn't shown the response url" do
      stub_namely_request("fields_without_greenhouse")
      user = create(:user)
      create(
        :greenhouse_connection,
        :connected,
        user: user,
        found_namely_field: false,
      )

      visit dashboard_path(as: user)

      within(".greenhouse-account") do
        expect(page).to have_content t(
          "dashboards.show.missing_namely_field",
          name: "greenhouse_id",
        )
      end
    end
  end

  def stub_namely_request(fixture_file)
    stub_request(:get, /.*api\/v1\/profiles\/fields/)
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/#{ fixture_file }.json"))
  end
end
