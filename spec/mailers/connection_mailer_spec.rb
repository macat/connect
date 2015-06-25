require "rails_helper"

describe ConnectionMailer do
  it "provides integration name in the subject, addresses the email, and " \
  "describes the problem" do
    connection_type = "icims"
    email = "test@example.com"
    mailer = ConnectionMailer.authentication_notification(
      connection_type: connection_type,
      email: email
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
  end
end
