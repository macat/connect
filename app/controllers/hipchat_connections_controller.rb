class HipchatConnectionsController < ApplicationController
  def edit
    @hipchat_connection = current_user.hipchat_connection
  end

  def update
    @hipchat_connection = current_user.hipchat_connection
    if @hipchat_connection.update(hipchat_connection_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  def destroy
    current_user.hipchat_connection.disconnect
    redirect_to dashboard_path
  end

  private

  def hipchat_connection_params
    params.require(:hipchat_connection).permit(
      :api_key,
    )
  end
end
