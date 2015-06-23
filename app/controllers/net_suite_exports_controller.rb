class NetSuiteExportsController < ApplicationController
  def create
    export = NetSuite::Export.new(
      namely_profiles: current_user.namely_connection.profiles.all,
      net_suite: net_suite_client
    )
    @results = export.perform
  end

  private

  def net_suite_client
    NetSuite::Client.new(
      user_secret: ENV.fetch("CLOUD_ELEMENTS_USER_SECRET"),
      organization_secret: ENV.fetch("CLOUD_ELEMENTS_ORGANIZATION_SECRET"),
      element_secret: current_user.net_suite_connection.authorization
    )
  end
end
