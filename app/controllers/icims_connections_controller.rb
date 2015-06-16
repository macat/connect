class IcimsConnectionsController < ApplicationController
  #require "base_connections_controller"
  include BaseConnectionsController

  private

  def connection_type
    :icims_connection
  end

  def connection_form_class
    Icims::ConnectionForm
  end

  def form_params_keys
    [:customer_id, :key, :username]
  end
end
