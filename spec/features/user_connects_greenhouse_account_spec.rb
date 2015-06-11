require "rails_helper"

feature "User connects Greenhouse account" do
  before do
    stub_request(:get, /.*api\/v1\/profiles\/fields/)
      .to_return(
        status: 200,
        body: File.read("spec/fixtures/api_responses/fields_with_greenhouse.json")
      )
  end

  scenario "successfully" do
    user = create(:user)
    allow(SecureRandom).to receive(:hex).and_return("greenhouse_key")

    visit dashboard_path(as: user)

    within(".greenhouse-account") do
      expect(page).to have_no_link t("dashboards.show.edit")
      click_link t("dashboards.show.connect")
    end

    fill_in field("greenhouse_connection.name"), with: "name"
    click_button button("greenhouse_connection.update")

    within(".greenhouse-account") do
      expect(page).to have_no_link t("dashboards.show.connect")
      expect(page).to have_content(greenhouse_candidate_imports_url("greenhouse_key"))
    end
  end
end
