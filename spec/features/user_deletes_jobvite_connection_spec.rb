require "rails_helper"

feature "User deletes Jobvite connection" do
  scenario "successfully" do
    user = create(:user)
    jobvite_connection = create(
      :jobvite_connection,
      user: user,
      api_key: "12345",
      secret: "abcde"
    )

    visit dashboard_path(as: user)

    expect(page).to have_content t("dashboards.show.disconnect")

    click_link t("dashboards.show.disconnect")

    expect(page).not_to have_content t("dashboards.show.disconnect")
    expect(page).to have_content t("dashboards.show.connect")
  end
end
