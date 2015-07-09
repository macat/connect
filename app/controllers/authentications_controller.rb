class AuthenticationsController < IntegrationController
  def new
    authentication
  end

  def create
    if authentication.update(authentication_params)
      redirect_to after_save_path
    else
      render :new
    end
  end

  private

  def authentication
    @authentication ||= AuthenticationFactory.create(
      connection: connection,
      integration_id: integration_id
    )
  end

  def after_save_path
    if connection.ready?
      dashboard_path
    else
      edit_integration_connection_path(integration_id)
    end
  end

  def authentication_params
    params.require(:"#{integration_id}_authentication").
      permit(authentication.allowed_parameters)
  end
end
