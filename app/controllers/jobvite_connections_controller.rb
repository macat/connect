class JobviteConnectionsController < ApplicationController
  def edit
    @jobvite_connection = current_user.jobvite_connection
  end

  def update
    @jobvite_connection = current_user.jobvite_connection
    ConnectionUpdater.new(jobvite_connection_params, @jobvite_connection).update
    redirect_to dashboard_path
  rescue ConnectionUpdater::FailedUpdate
    render :edit
  end

  def destroy
    current_user.jobvite_connection.disconnect
    redirect_to dashboard_path
  end

  private

  def jobvite_connection_params
    params.require(:jobvite_connection).permit(
      :api_key,
      :hired_workflow_state,
      :secret,
    )
  end
end
