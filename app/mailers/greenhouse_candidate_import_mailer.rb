class GreenhouseCandidateImportMailer < ApplicationMailer
  def successful_import(user, candidate_name)
    @user = user 
    mail to: @user.email, subject: t(".subject", name: candidate_name) 
  end

  def unsuccessful_import(user, candidate_name, status)
    @user = user
    @candidate_name = candidate_name
    @status = status

    mail to: @user.email, subject: t(".subject", name: candidate_name)
  end
end
