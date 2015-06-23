class NetSuiteExportsController < ApplicationController
  def create
    export = NetSuite::Export.new(
      namely_profiles: current_user.namely_profiles.all,
      net_suite: current_user.net_suite_connection.client
    )
    @results = export.perform
  end
end
