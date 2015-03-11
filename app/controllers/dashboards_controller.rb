class DashboardsController < ApplicationController
  def show
    @jobvite_connection = current_user.jobvite_connection
    @icims_connection = current_user.icims_connection
  end
end
