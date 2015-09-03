class UnauthorizedNotifier
  def self.deliver(connection:, exception:)
    new(connection: connection, exception: exception).deliver
  end

  def initialize(connection:, exception:)
    @connection = connection
    @exception = exception
  end

  def deliver
    record_sync_summary
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

  def record_sync_summary
    SyncSummary.create!(
      connection: connection,
      authorization_error: exception.message
    )
  end

  def installation
    connection.installation
  end

  def integration_id
    connection.integration_id
  end
end
