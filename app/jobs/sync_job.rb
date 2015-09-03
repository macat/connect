class SyncJob < ActiveJob::Base
  def perform(connection)
    results = connection.sync
    deliver_sync_notification(connection, results)
  rescue Unauthorized => exception
    deliver_unauthorized_notification(connection, exception)
  end

  private

  def deliver_sync_notification(connection, results)
    SyncNotifier.deliver(
      results: results,
      installation: connection.installation,
      integration_id: connection.integration_id
    )
  end

  def deliver_unauthorized_notification(connection, exception)
    UnauthorizedNotifier.deliver(
      connection: connection,
      exception: exception
    )
  end
end
