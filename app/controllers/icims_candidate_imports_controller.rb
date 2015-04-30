class IcimsCandidateImportsController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token

  def create
    service = Icims::CandidateImporter.new(Icims::Connection, params)
    service.import
    mailer.delay.successful_import(service.user, service.candidate)
  rescue Icims::CandidateImporter::FailedImport
    mailer.delay.unsuccessful_import(service.user, 
                                     service.candidate, 
                                     service.imported_result)
  rescue Icims::Client::Error => e
    mailer.delay.unauthorized_import(service.user, e.message)
  ensure 
    render text: nil
  end

  def mailer
    IcimsCandidateImportMailer
  end
end
