class DashboardsController < ApplicationController
  def show
    @connections = [
      Jobvite::ConnectionPresenter.new(current_user.jobvite_connection),
      Icims::ConnectionPresenter.new(current_user.icims_connection),
    ]
  end
end
