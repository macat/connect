class GreenhouseConnectionsController < ApplicationController
  def edit 
    @greenhouse_connection = current_user.greenhouse_connection
  end
end
