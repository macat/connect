class ConnectionsController < ApplicationController
  def edit
    connection_form
    render edit_template
  end

  def update
    if connection_form.update(form_params)
      redirect_to dashboard_path
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
      form_type: form_type
    )
  end

  def connection
    @connection ||= current_user.send(form_type)
  end

  def edit_template
    form_type.pluralize + "/edit"
  end

  def form_params
    params.require(form_type).permit(
      connection_form.allowed_parameters
    )
  end

  def form_type
    params[:form_type].to_s
  end
end
