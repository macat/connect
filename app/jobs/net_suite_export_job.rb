class NetSuiteExportJob
  def initialize(user_id)
    @user_id = user_id
  end

  def perform
    results = export
    deliver_notification results
  end

  private

  def export
    NetSuite::Export.new(
      configuration: user.net_suite_connection,
      namely_profiles: user.namely_profiles.all,
      net_suite: user.net_suite_connection.client
    ).perform
  end

  def deliver_notification(results)
    SyncMailer.net_suite_notification(
      email: user.email,
      results: results
    ).deliver
  end

  def user
    @user ||= User.find(@user_id)
  end
end
