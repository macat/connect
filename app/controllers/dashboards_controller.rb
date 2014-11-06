class DashboardsController < ApplicationController
  def show
    @jobvite_connection = current_user.jobvite_connection
  end
end
