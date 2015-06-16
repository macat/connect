require "rails_helper"

feature "user connects NetSuite account" do
  scenario "successfully" do
    stub_create_instance(status: 200, body: { id: "123", token: "abcxyz" })

    visit_dashboard

    expect(net_suite).not_to have_link(t("dashboards.show.edit"))
    net_suite.click_link t("dashboards.show.connect")

    submit_net_suite_form
    expect(net_suite).not_to have_link(t("dashboards.show.connect"))
  end

  scenario "with bad authentication" do
    stub_create_instance(status: 400, body: { message: "Not good" })

    visit_dashboard

    net_suite.click_link t("dashboards.show.connect")

    submit_net_suite_form
    expect(page).to have_content("Not good")
  end

  def visit_dashboard
    user = create(:user)
    visit dashboard_path(as: user)
  end

  def submit_net_suite_form
    fill_in field("net_suite_connection.email"), with: "user@example.com"
    fill_in field("net_suite_connection.account_id"), with: "12345"
    fill_in field("net_suite_connection.password"), with: "secret"
    click_button button("net_suite_connection.update")
  end

  def stub_create_instance(status:, body:)
    stub_request(
      :post,
      "https://api.cloud-elements.com/elements/api-v2/instances"
    ).to_return(status: status, body: JSON.dump(body))
  end

  def net_suite
    page.find(".net-suite-account")
  end
end
