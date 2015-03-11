class IcimsConnectionsController < ApplicationController
  def edit
    @icims_connection = current_user.icims_connection
  end

  def update
    @icims_connection = current_user.icims_connection
    if @icims_connection.update(icims_connection_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def icims_connection_params
    params.require(:icims_connection).permit(
      :password,
      :username,
    )
  end
end
