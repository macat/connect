class DashboardsController < ApplicationController
  def show
    @connections = decorate([
      current_user.jobvite_connection,
      current_user.icims_connection,
      current_user.greenhouse_connection,
      current_user.net_suite_connection
    ])
  end

  private

  def decorate(connections)
    connections.map do |connection|
      UserCheckNamelyField.new(connection)
    end
  end
end
