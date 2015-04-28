class GreenhouseConnectionsController < ApplicationController
  def edit 
    greenhouse_connection
  end

  def update
    ConnectionUpdater.new(greenhouse_connection_params, greenhouse_connection).update
    redirect_to dashboard_path
  rescue ConnectionUpdater::UpdateFailed
    render :edit
  end

  private 

  def greenhouse_connection_params
    params.require(:greenhouse_connection).permit(:name)
  end

  def greenhouse_connection
    @greenhouse_connection ||= current_user.greenhouse_connection
  end
end
