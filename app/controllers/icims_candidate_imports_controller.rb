class IcimsCandidateImportsController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token

  def create
    Icims::CandidateImporter.new(connection,
                                 IcimsCandidateImportMailer,
                                 params).import
    render nothing: true
  end

  private

  def connection
    Icims::Connection.find_by(api_key: params[:api_key],
                              customer_id: params[:customerId])
  end
end
