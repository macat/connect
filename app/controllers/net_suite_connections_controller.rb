class NetSuiteConnectionsController < ApplicationController
  include BaseConnectionsController

  private

  def connection_type
    :net_suite_connection
  end

  def connection_form
    @connection_form ||= NetSuite::ConnectionForm.new(
      client: client,
      connection: connection
    )
  end

  def client
    NetSuite::Client.new(
      user_secret: ENV.fetch("CLOUD_ELEMENTS_USER_SECRET"),
      organization_secret: ENV.fetch("CLOUD_ELEMENTS_ORGANIZATION_SECRET")
    )
  end

  def form_params_keys
    [:account_id, :email, :password]
  end
end
