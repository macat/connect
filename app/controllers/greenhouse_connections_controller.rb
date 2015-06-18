class GreenhouseConnectionsController < ApplicationController
  include BaseConnectionsController

  private

  def connection_type
    :greenhouse_connection
  end

  def connection_form_class
    Greenhouse::ConnectionForm
  end

  def form_params_keys
    [:name, :secret_key]
  end
end
