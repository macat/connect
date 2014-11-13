require "rails_helper"

feature "User visits their dashboard" do
  scenario "with a Jobvite connection, but no Jobvite field on Namely" do
    user = create(:user)
    create(
      :jobvite_connection,
      :connected,
      user: user,
      found_namely_field: false,
    )

    VCR.use_cassette("namely_fields_without_jobvite_id") do
      visit dashboard_path(as: user)

      expect(page).to have_content t(
        "dashboards.show.missing_namely_field",
        name: "jobvite_id",
      )
    end
  end

  scenario "with a Jobvite connection, and a Jobvite field on Namely" do
    user = create(:user)
    create(
      :jobvite_connection,
      :connected,
      user: user,
      found_namely_field: true,
    )

    visit dashboard_path(as: user)

    expect(page).not_to have_content t(
      "dashboards.show.missing_namely_field",
      name: "jobvite_id",
    )
  end
end
