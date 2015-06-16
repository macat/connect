module BaseConnectionsController
  def edit
    connection_form
  end

  def update
    if connection_form.update(form_params)
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

  def abstract_method
    raise UnimplementedAbstractMethod,
      t(
        "exceptions.unimplemented_abstract_method",
        method_name: abstract_method_name
      )
  end

  def abstract_method_name
    caller_locations(1,1)[0].label
  end

  def client
    abstract_method
  end

  def connection_form
    @connection_form ||= connection_form_class.new(
      connection: connection
    )
  end

  def connection_form_class
    abstract_method
  end

  def connection_type
    abstract_method
  end

  def form_params_keys
    abstract_method
  end

  def form_params
    params.require(connection_type).permit(form_params_keys)
  end

  def connection
    @connection ||= current_user.send(connection_type)
  end

  class UnimplementedAbstractMethod < StandardError; end
end
