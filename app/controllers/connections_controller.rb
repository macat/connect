class ConnectionsController < IntegrationController
  def edit
    connection
  end

  def update
    if update_connection
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  def destroy
    connection.disconnect
    redirect_to dashboard_path
  end

  private

  def update_connection
    connection.update(connection_params) && connection.ready?
  end

  def connection_params
    params.require(connection_type).permit(connection.allowed_parameters)
  end
end
