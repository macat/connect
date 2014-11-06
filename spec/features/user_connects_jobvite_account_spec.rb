require "rails_helper"

feature "User connects jobvite account" do
  scenario "successfully" do
    user = create(:user)
    jobvite_api_key = "12345"
    jobvite_secret = "abcde"

    visit dashboard_path(as: user)

    expect(page).not_to have_link t("dashboards.show.edit")

    click_link t("dashboards.show.connect")
    fill_in field("jobvite_connection.api_key"), with: jobvite_api_key
    fill_in field("jobvite_connection.secret"), with: jobvite_secret
    click_button button("jobvite_connection.update")

    expect(page).to have_content jobvite_api_key
    expect(page).to have_link t("dashboards.show.edit")
    expect(page).not_to have_link t("dashboards.show.connect")
  end
end
