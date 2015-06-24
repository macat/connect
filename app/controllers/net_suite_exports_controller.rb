class NetSuiteExportsController < ApplicationController
  def create
    export = NetSuite::Export.new(
      namely_profiles: current_user.namely_profiles.all,
      net_suite: current_user.net_suite_connection.client
    )
    @results = export.perform
    send_results_email(@results)
  end

  private

  def send_results_email(results)
    SyncMailer.net_suite_notification(
      email: current_user.email,
      results: results
    ).deliver
  end
end
