class ConnectionMailer < ApplicationMailer
  def authentication_notification(integration_id:, email:, message:)
    @integration = map_integration_id_to_name(integration_id)
    @message = message

    mail(
      to: email,
      subject: t(
        "connection_mailer.authentication_notification.subject",
        integration: @integration
      )
    )
  end
end
