class SyncJob
  def initialize(integration_id, user_id)
    @integration_id = integration_id
    @user_id = user_id
  end

  def perform
    results = connection.sync
    deliver_sync_notification results
  rescue Unauthorized => exception
    log_unauthorized_exception(exception)
    deliver_unauthorized_notification
  end

  private

  def connection
    user.send(:"#{@integration_id}_connection")
  end

  def deliver_sync_notification(results)
    SyncMailer.sync_notification(
      email: user.email,
      integration_id: @integration_id,
      results: results
    ).deliver
  end

  def deliver_unauthorized_notification
    user.send_connection_notification(@integration_id)
  end

  def integration_name
    I18n.t("#{@integration_id}.name")
  end

  def log_unauthorized_exception(exception)
    Rails.logger.error(
      "#{exception.class} error #{exception.message} for user_id: #{user.id} " \
      "with #{integration_name}"
    )
  end

  def user
    @user ||= User.find(@user_id)
  end
end
