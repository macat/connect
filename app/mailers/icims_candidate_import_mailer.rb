class IcimsCandidateImportMailer < ApplicationMailer
  def successful_import(user, candidate)
    @user = user
    @candidate = candidate
    mail(
      to: @user.email,
      subject: t(
        "icims_candidate_import_mailer.successful_import.subject",
        name: @candidate.name
      )
    )
  end

  def unsuccessful_import(user, candidate, status)
    @user = user
    @candidate = candidate
    @status = status

    mail(
      to: @user.email,
      subject: t(
        "icims_candidate_import_mailer.unsuccessful_import.subject",
        name: @candidate.name
      )
    )
  end

  def unauthorized_import(user, error_message)
    @user = user
    @error_message = error_message

    mail(
      to: @user.email,
      subject: t("icims_candidate_import_mailer.unauthorized_import.subject")
    )
  end
end
