class IntegrationController < ApplicationController
  private

  def connection
    @connection ||= current_user.send(connection_type)
  end

  def connection_type
    "#{integration_id}_connection"
  end

  def integration_id
    params[:integration_id]
  end
end
