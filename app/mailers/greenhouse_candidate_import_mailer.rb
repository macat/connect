class GreenhouseCandidateImportMailer < ApplicationMailer
  def successful_import(user, candidate_name)
    @user = user 
    mail to: @user.email, subject: t(".subject", name: candidate_name) 
  end
end
