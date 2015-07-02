class SyncJob
  def initialize(integration_id, user_id)
    @integration_id = integration_id
    @user_id = user_id
  end

  def perform
    results = connection.sync
    deliver_sync_notification results
  rescue Unauthorized => exception
    notifier.log_and_notify_of_unauthorized_exception(exception)
  end

  private

  def connection
    user.send(:"#{@integration_id}_connection")
  end

  def deliver_sync_notification(results)
    SyncMailer.sync_notification(
      email: user.email,
      integration_id: integration_id,
      results: results
    ).deliver
  end

  def notifier
    AuthenticationNotifier.new(
      integration_id: integration_id,
      user: user
    )
  end

  def user
    @user ||= User.find(@user_id)
  end

  attr_reader :integration_id
end
