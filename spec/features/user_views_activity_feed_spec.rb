require "rails_helper"

feature "User views activity feed" do
  scenario "with successful syncs" do
    view_activity_feed do |connection|
      sync_summary = create(:sync_summary, connection: connection)
      create(:profile_event, sync_summary: sync_summary, profile_name: "Adam")
      create(:profile_event, sync_summary: sync_summary, profile_name: "Ali")
      create(:profile_event, sync_summary: sync_summary, profile_name: "Amy")
    end

    expect(page).to have_text("Successfully synced 3 profiles")
    expect(page).to have_text("Adam")
    expect(page).to have_text("Ali")
    expect(page).to have_text("Amy")
  end

  scenario "with some failed profiles" do
    view_activity_feed do |connection|
      sync_summary = create(:sync_summary, connection: connection)
      create(
        :profile_event,
        sync_summary: sync_summary,
        profile_name: "Adam",
        error: nil
      )
      create(
        :profile_event,
        sync_summary: sync_summary,
        profile_name: "Ali",
        error: "Phone number is invalid"
      )
      create(
        :profile_event,
        sync_summary: sync_summary,
        profile_name: "Amy",
        error: "Email is required"
      )
    end

    expect(page).to have_text("Successfully synced one profile")
    expect(page).to have_text("Adam")
    expect(page).to have_text("Unable to sync 2 profiles")
    expect(page).to have_text("Ali")
    expect(page).to have_text("Phone number is invalid")
    expect(page).to have_text("Amy")
    expect(page).to have_text("Email is required")
  end

  def view_activity_feed
    user = create(:user)
    connection = create(
      :net_suite_connection,
      :ready,
      installation: user.installation
    )

    yield connection

    visit dashboard_path(as: user)
    find(".net-suite-account").click_link(t("dashboards.show.activity_feed"))
  end
end
