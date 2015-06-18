class JobviteConnectionsController < ApplicationController
  include BaseConnectionsController

  private

  def connection_type
    :jobvite_connection
  end

  def connection_form_class
    Jobvite::ConnectionForm
  end

  def form_params_keys
    [:api_key, :secret]
  end
end
