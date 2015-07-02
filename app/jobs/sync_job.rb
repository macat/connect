class SyncJob
  def initialize(integration_id, user_id)
    @integration_id = integration_id
    @user_id = user_id
  end

  def perform
    results = connection.sync
    deliver_notification results
  end

  private

  def connection
    user.send(:"#{@integration_id}_connection")
  end

  def deliver_notification(results)
    SyncMailer.sync_notification(
      email: user.email,
      integration_id: @integration_id,
      results: results
    ).deliver
  end

  def user
    @user ||= User.find(@user_id)
  end
end
