require "rails_helper"

feature "User imports jobvite candidates" do
  before do
    stub_request(:get, /.*api.jobvite.com\/api\/v2\/candidate/)
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/jobvite_candidates.json"))
  end

  before do
    stub_request(:get, "#{ api_host }/api/v1/profiles")
      .with(query: {access_token: ENV['TEST_NAMELY_ACCESS_TOKEN'], limit: 'all'})
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/empty_profiles.json"))
  end

  let(:api_host) do
    "%{protocol}://%{subdomain}.namely.com" % {
      protocol: Rails.configuration.namely_api_protocol,
      subdomain: ENV['TEST_NAMELY_SUBDOMAIN'],
    }
  end

  scenario "successfully without failed imported candidates" do
    stub_namely_fields("fields_with_jobvite")
    stub_request(:post, "#{ api_host }/api/v1/profiles")
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/not_empty_profiles.json"))

    user = create(:user)
    create(
      :jobvite_connection,
      user: user,
      api_key: ENV.fetch("TEST_JOBVITE_KEY"),
      secret: ENV.fetch("TEST_JOBVITE_SECRET"),
    )

    visit dashboard_path(as: user)
    within(".jobvite-account") do
      click_button t("dashboards.show.import_now")
    end

    expect(page).to have_content t("syncs.create.slogan",
                                   integration: "Jobvite")

    open_email user.email
    expect(current_email).to have_text(
      t(
        "sync_mailer.sync_notification.succeeded",
        employees: t("sync_mailer.sync_notification.employees", count: 6),
        integration: "Jobvite"
      )
    )
  end

  scenario "successfully with failed import candidates" do
    stub_namely_fields("fields_with_jobvite")
    stub_request(:post, "#{ api_host }/api/v1/profiles")
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/empty_profiles.json"))

    user = create(:user)
    create(
      :jobvite_connection,
      user: user,
      api_key: ENV.fetch("TEST_JOBVITE_KEY"),
      secret: ENV.fetch("TEST_JOBVITE_SECRET"),
    )

    visit dashboard_path(as: user)
    within(".jobvite-account") do
      click_button t("dashboards.show.import_now")
    end

    expect(page).to have_content t("syncs.create.slogan",
                                   integration: "Jobvite")

    open_email user.email
    expect(current_email).to have_text(
      t(
        "sync_mailer.sync_notification.failed",
        employees: t("sync_mailer.sync_notification.employees", count: 6),
        integration: "Jobvite"
      )
    )
  end

  scenario "with bad authentication" do
    stub_namely_fields("fields_with_jobvite")
    stub_request(:get, /.*api.jobvite.com\/api\/v2\/candidate/).
      to_return(status: 200, body: authentication_error_as_json)

    user = create(:user)
    create(
      :jobvite_connection,
      api_key: ENV.fetch("TEST_JOBVITE_KEY"),
      secret: ENV.fetch("TEST_JOBVITE_SECRET"),
      user: user
    )

    visit dashboard_path(as: user)
    within(".jobvite-account") do
      click_button t("dashboards.show.import_now")
    end

    expect(page).to have_content t("syncs.create.slogan",
                                   integration: "Jobvite")

    open_email user.email
    expect(current_email).to have_text(
      t(
        "connection_mailer.authentication_notification.notice",
        integration: "Jobvite"
      )
    )
  end

  def authentication_error_as_json
    <<-JSON
      {
        "status": "INVALID_KEY_SECRET",
        "responseMessage": "An error message"
      }
    JSON
  end
end
