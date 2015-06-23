require "rails_helper"

feature "user exports to net suite" do
  scenario "successfully" do
    user = create(:user)
    stub_namely_data("/profiles", "profiles_with_net_suite_fields")
    stub_request(:put, %r{.*api/v1/profiles/.*}).to_return(status: 200)
    stub_request(
      :post,
      "https://api.cloud-elements.com/elements/api-v2/hubs/erp/employees"
    ).
      with(body: /Sally/).
      to_return(status: 200, body: { "internalId" => "123" }.to_json)
    stub_request(
      :patch,
      "https://api.cloud-elements.com/elements/api-v2/hubs/erp/employees/1234"
    ).
      with(body: /Tina/).
      to_return(status: 200, body: { "internalId" => "1234" }.to_json)
    stub_request(
      :post,
      "https://api.cloud-elements.com/elements/api-v2/hubs/erp/employees"
    ).
      with(body: /Mickey/).
      to_return(status: 400, body: { "message" => "Bad Data" }.to_json)
    stub_namely_fields("fields_with_net_suite")
    create(:net_suite_connection, :connected, user: user)
    visit dashboard_path(as: user)

    find(".net-suite-account").click_on t("dashboards.show.export_now")

    expect(page).to have_content("Processed 3 employees")
    expect(page).to have_content("Exported new employee: Sally Smith")
    expect(page).to have_content("Exported updates for employee: Tina Tech")
    expect(page).to have_content("Couldn't export: Mickey Moore")
    expect(page).to have_content("Bad Data")
  end
end
