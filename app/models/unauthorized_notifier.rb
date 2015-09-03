class UnauthorizedNotifier
  def self.deliver(connection:, exception:)
    new(connection: connection, exception: exception).deliver
  end

  def initialize(connection:, exception:)
    @connection = connection
    @exception = exception
  end

  def integration_name
    I18n.t("#{integration_id}.name")
  end

  def deliver
    log_unauthorized_exception
    deliver_unauthorized_notification
  end

  private

  attr_reader :connection, :exception

  def deliver_unauthorized_notification
    installation.send_connection_notification(
      integration_id: integration_id,
      message: exception.message
    )
  end

  def log_unauthorized_exception
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
