class JobviteConnectionsController < ApplicationController
  def edit
    @jobvite_connection = current_user.jobvite_connection
  end

  def update
    @jobvite_connection = current_user.jobvite_connection
    connection_updater = Jobvite::ConnectionUpdater.
      new(@jobvite_connection)

    connection_updater.on(:connection_updated_successfully) do
      redirect_to dashboard_path
    end

    connection_updater.on(:connection_updated_unsuccessfully) do
      render :edit
    end
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
