require "rails_helper"

feature "Visitor authenticates with Namely" do
  class FakeNamely
    def call(env)
      request = Rack::Request.new(env)
      redirect_uri = "%{base_uri}?code=%{code}&state=%{state}" % {
        base_uri: request["redirect_uri"],
        code: ENV.fetch("TEST_NAMELY_AUTH_CODE"),
        state: request["state"],
      }
      Rack::Response.new([], 302, { "Location" => redirect_uri }).to_a
    end
  end

  scenario "successfully", :js do
    Capybara::Discoball.spin(FakeNamely) do |server|
      Rails.configuration.namely_authentication_domain = "#{server.host}:#{server.port}"
      Rails.configuration.namely_authentication_protocol = "http"
    end

    VCR.use_cassette("token_exchange") do
      visit root_path
      fill_in field("namely_authentication.subdomain"), with: "sales14"
      click_button button("namely_authentication.submit")

      expect(page.current_path).to eq dashboard_path
      expect(page).to have_content "Admin Admin"
    end
  end
end
