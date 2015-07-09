module IntegrationHelper
  def integration_name
    I18n.t("#{integration_id}.name")
  end
end
