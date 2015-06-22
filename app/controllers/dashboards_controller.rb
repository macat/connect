class DashboardsController < ApplicationController
  def show
    @connections = decorate([
      Jobvite::ConnectionPresenter.new(current_user.jobvite_connection),
      Icims::ConnectionPresenter.new(current_user.icims_connection),
      Greenhouse::ConnectionPresenter.new(current_user.greenhouse_connection),
      NetSuite::ConnectionPresenter.new(current_user.net_suite_connection)
    ])
  end

  private

  def decorate(connections)
    connections.map do |connection|
      UserCheckNamelyField.new(connection)
    end
  end
end
