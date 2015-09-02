class SyncNotifier
  def self.deliver(installation:, integration_id:, results:)
    new(
      installation: installation,
      integration_id: integration_id,
      results: results
    ).deliver
  end

  def initialize(installation:, integration_id:, results:)
    @installation = installation
    @integration_id = integration_id
    @results = results
  end

  def deliver
    deliver_emails
    record_sync_summary
  end

  private

  attr_reader :installation, :integration_id, :results

  def deliver_emails
    users.each do |user|
      SyncMailer.sync_notification(
        email: user.email,
        integration_id: integration_id,
        results: results
      ).deliver_now
    end
  end

  def record_sync_summary
    SyncSummary.create_from_results!(
      connection: connection,
      results: results
    )
  end

  def users
    installation.users
  end

  def connection
    installation.connection_to(integration_id)
  end
end
