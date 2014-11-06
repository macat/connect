class JobviteConnectionsController < ApplicationController
  def edit
    @jobvite_connection = current_user.jobvite_connection
  end

  def update
    @jobvite_connection = current_user.jobvite_connection
    if @jobvite_connection.update(jobvite_connection_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  def destroy
    current_user.jobvite_connection.disconnect
    redirect_to dashboard_path
  end

  private

  def jobvite_connection_params
    params.require(:jobvite_connection).permit(:api_key, :secret)
  end
end
