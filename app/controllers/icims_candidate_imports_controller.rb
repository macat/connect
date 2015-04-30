class IcimsCandidateImportsController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token

  def create
    Icims::CandidateImporter.new(Icims::Connection, 
                                 IcimsCandidateImportMailer, 
                                 params).import
    render nothing: true
  end
end
