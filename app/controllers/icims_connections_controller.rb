class IcimsConnectionsController < ApplicationController
  def edit
    icims_connection
  end

  def update
    ConnectionUpdater.new(icims_connection_params, icims_connection).update
    redirect_to dashboard_path
  rescue ConnectionUpdater::UpdateFailed
    render :edit
  end

  def destroy
    icims_connection.disconnect
    redirect_to dashboard_path
  end

  private

  def icims_connection_params
    params.require(:icims_connection).permit(
      :customer_id,
      :key,
      :username,
    )
  end

  def icims_connection
    @icims_connection ||= current_user.icims_connection
  end
end
