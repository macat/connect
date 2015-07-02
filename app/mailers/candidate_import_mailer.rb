class CandidateImportMailer < ApplicationMailer
  def successful_import(candidate:, integration_id:, email:)
    @integration = map_integration_id_to_name(integration_id)
    @candidate = candidate

    mail(
      to: email,
      subject: t(
        "candidate_import_mailer.successful_import.subject",
        candidate_name: @candidate.name,
        integration: @integration
      )
    )
  end

  def unsuccessful_import(candidate:, integration_id:, email:, status:)
    @candidate = candidate
    @integration = map_integration_id_to_name(integration_id)
    @integration_id = integration_id
    @status = status

    mail(
      to: email,
      subject: t(
        "candidate_import_mailer.unsuccessful_import.subject",
        candidate_name: @candidate.name,
        integration: @integration
      )
    )
  end
end
