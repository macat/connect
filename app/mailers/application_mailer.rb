class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@namely.com"

  private

  def map_integration_id_to_name(integration_id)
    t("#{integration_id}.name")
  end
end
