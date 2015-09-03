class UnauthorizedNotifier
  def initialize(connection)
    @connection = connection
  end

  def integration_name
    I18n.t("#{integration_id}.name")
  end

  def log_and_notify_of_unauthorized_exception(exception)
    log_unauthorized_exception(exception)
    deliver_unauthorized_notification(exception)
  end

  private

  attr_reader :connection

  def deliver_unauthorized_notification(exception)
    installation.send_connection_notification(
      integration_id: integration_id,
      message: exception.message
    )
  end

  def log_unauthorized_exception(exception)
    Rails.logger.error(
      "#{exception.class} error #{exception.message} for " \
      "installation_id: #{installation.id} with #{integration_name}"
    )
  end

  def installation
    connection.installation
  end

  def integration_id
    connection.integration_id
  end
end
