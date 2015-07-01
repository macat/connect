class ConnectionMailer < ApplicationMailer
  def authentication_notification(connection_type:, email:)
    @integration = map_connection_type_to_integration(connection_type)

    mail(
      to: email,
      subject: t(
        "connection_mailer.authentication_notification.subject",
        integration: @integration
      )
    )
  end

  private

  def map_connection_type_to_integration(connection_type)
    t("#{connection_type}.name")
  end
end
