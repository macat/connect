require "rails_helper"

feature "User connects jobvite account" do
  before do
    stub_request(:get, /.*api\/v1\/profiles\/fields/)
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/fields_with_jobvite.json"))
  end
  scenario "successfully" do
    user = create(:user)

    visit dashboard_path(as: user)

    expect(page).not_to have_link t("dashboards.show.edit")

    within(".connection-jobvite") do
      click_link t("dashboards.show.connect")
    end
    fill_in field("jobvite_connection.api_key"), with: "12345"
    fill_in field("jobvite_connection.secret"), with: "abcde"
    click_button button("jobvite_connection.update")

    within(".connection-jobvite") do
      expect(page).not_to have_link t("dashboards.show.connect")
    end
  end
end
