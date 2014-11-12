require "rails_helper"

feature "User imports jobvite candidates" do
  scenario "successfully" do
    user = create(:user)
    create(
      :jobvite_connection,
      user: user,
      api_key: ENV.fetch("TEST_JOBVITE_KEY"),
      secret: ENV.fetch("TEST_JOBVITE_SECRET"),
    )

    VCR.use_cassette("jobvite_import") do
      visit dashboard_path(as: user)
      click_button t("dashboards.show.import_now")

      expect(page).to have_content t("status.success")
    end
  end
end
