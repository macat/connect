require "rails_helper"

feature "User deletes Jobvite connection" do
  scenario "successfully" do
    user = create(:user)
    jobvite_connection = create(
      :jobvite_connection,
      :connected,
      user: user,
      found_namely_field: true,
    )

    visit dashboard_path(as: user)

    expect(page).to have_link t("dashboards.show.disconnect")

    click_link t("dashboards.show.disconnect")

    expect(page).not_to have_button t("dashboards.show.disconnect")
    expect(page).to have_link t("dashboards.show.connect")
  end
end
