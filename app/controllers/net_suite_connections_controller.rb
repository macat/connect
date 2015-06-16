class NetSuiteConnectionsController < ApplicationController
  def edit
    net_suite_connection_request
  end

  def update
    if net_suite_connection_request.update(request_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def net_suite_connection_request
    @net_suite_connection_request ||= NetSuite::ConnectionRequest.new(
      client: client,
      connection: net_suite_connection
    )
  end

  def net_suite_connection
    @net_suite_connection ||= current_user.net_suite_connection
  end

  def client
    NetSuite::Client.new(
      user_secret: ENV.fetch("CLOUD_ELEMENTS_USER_SECRET"),
      organization_secret: ENV.fetch("CLOUD_ELEMENTS_ORGANIZATION_SECRET")
    )
  end

  def request_params
    params.
      require(:net_suite_connection).
      permit(:account_id, :email, :password)
  end
end
