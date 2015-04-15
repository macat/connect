class IcimsCandidateImportMailer < ApplicationMailer
  def successful_import(user, candidate)
    @user = user
    @candidate = candidate
    mail to: @user.email, subject: t(".subject", name: @candidate.name)
  end
end
