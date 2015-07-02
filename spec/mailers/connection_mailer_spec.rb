require "rails_helper"

describe ConnectionMailer do
  it "provides integration name in the subject, addresses the email, and " \
  "describes the problem" do
    integration_id = "icims"
    email = "test@example.com"
    exception = Unauthorized.new("I can't do that, Dave")
    mailer = ConnectionMailer.authentication_notification(
      email: email,
      integration_id: integration_id,
      message: exception.message
    )

    expect(mailer.subject).to eq(
      t(
        "connection_mailer.authentication_notification.subject",
        integration: "iCIMS"
      )
    )
    expect(mailer.to).to match_array([email])
    expect(mailer.body.to_s).to include(
      t(
        "connection_mailer.authentication_notification.notice",
        integration: "iCIMS"
      )
    )
    expect(mailer.body.to_s).to include(
      t(
        "connection_mailer.authentication_notification.error_message",
        message: exception.message
      )
    )
  end
end
