class DashboardsController < ApplicationController
  before_action :require_login

  def show
    @jobvite_connection = current_user.jobvite_connection
  end
end
