require "rails_helper"

feature "User connects iCIMS account" do
  scenario "successfully" do
    user = create(:user)

    visit dashboard_path(as: user)

    within(".icims-account") do
      expect(page).to have_no_link t("dashboards.show.edit")
      click_link t("dashboards.show.connect")
    end

    fill_in field("icims_connection.username"), with: "username"
    fill_in field("icims_connection.key"), with: "key"
    fill_in field("icims_connection.customer_id"), with: 1
    click_button button("icims_connection.update")

    within(".icims-account") do
      expect(page).to have_no_link t("dashboards.show.connect")
    end
  end
end
