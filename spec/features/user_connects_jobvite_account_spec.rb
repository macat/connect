require "rails_helper"

feature "User connects jobvite account" do
  scenario "successfully" do
    user = create(:user)

    VCR.use_cassette("namely_fields_with_jobvite_id") do
      visit dashboard_path(as: user)

      expect(page).not_to have_link t("dashboards.show.edit")

      click_link t("dashboards.show.connect")
      fill_in field("jobvite_connection.api_key"), with: "12345"
      fill_in field("jobvite_connection.secret"), with: "abcde"
      click_button button("jobvite_connection.update")

      expect(page).not_to have_link t("dashboards.show.connect")
    end
  end
end
