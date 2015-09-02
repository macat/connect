class SyncJob
  def initialize(integration_id, installation_id)
    @integration_id = integration_id
    @installation_id = installation_id
  end

  def perform
    results = connection.sync
    deliver_sync_notification results
  rescue Unauthorized => exception
    notifier.log_and_notify_of_unauthorized_exception(exception)
  end

  private

  def connection
    installation.public_send("#{integration_id}_connection")
  end

  def deliver_sync_notification(results)
    SyncNotifier.deliver(
      results: results,
      installation: installation,
      integration_id: integration_id
    )
  end

  def notifier
    AuthenticationNotifier.new(
      integration_id: integration_id,
      installation: installation
    )
  end

  def installation
    @installation ||= Installation.find(@installation_id)
  end

  attr_reader :integration_id
end
