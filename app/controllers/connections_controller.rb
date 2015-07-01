class ConnectionsController < ApplicationController
  def new
    connection_form
    render new_template
  end

  def create
    if connection_form.update(form_params)
      redirect_to after_save_path
    else
      render new_template
    end
  end

  def edit
    connection
    render edit_template
  end

  def update
    if connection.update(form_params)
      redirect_to after_save_path
    else
      render edit_template
    end
  end

  def destroy
    connection.disconnect
    redirect_to dashboard_path
  end

  private

  def connection_form
    @connection_form ||= ConnectionFormFactory.create(
      connection: connection,
      integration_id: params[:integration_id]
    )
  end

  def connection
    @connection ||= current_user.send(connection_type)
  end

  def new_template
    connection_type.pluralize + "/new"
  end

  def edit_template
    connection_type.pluralize + "/edit"
  end

  def after_save_path
    if connection.ready?
      dashboard_path
    else
      edit_integration_connection_path(params[:integration_id])
    end
  end

  def form_params
    params.require(connection_type).permit(
      connection_form.allowed_parameters
    )
  end

  def connection_type
    "#{params[:integration_id]}_connection"
  end
end
