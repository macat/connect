require "rails_helper"

feature "User views activity feed" do
  scenario "with successful syncs" do
    user = create(:user)
    connection = create(
      :net_suite_connection,
      :ready,
      installation: user.installation
    )
    sync_summary = create(:sync_summary, connection: connection)
    create(:profile_event, sync_summary: sync_summary, profile_name: "Adam")
    create(:profile_event, sync_summary: sync_summary, profile_name: "Ali")
    create(:profile_event, sync_summary: sync_summary, profile_name: "Amy")

    visit dashboard_path(as: user)
    find(".net-suite-account").click_link(t("dashboards.show.activity_feed"))

    expect(page).to have_text("Successfully synced 3 profiles")
    expect(page).to have_text("Adam")
    expect(page).to have_text("Ali")
    expect(page).to have_text("Amy")
  end
end
