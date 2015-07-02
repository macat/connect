class GreenhouseCandidateImportsController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token

  def create
    Greenhouse::CandidatesImporter.new(
      GreenhouseCandidateImportMailer,
      Greenhouse::Connection,
      greenhouse_candidate_import_params,
      params['secret_key'],
      request.headers['Signature']).import

    render nothing: true, status: :ok
  rescue Unauthorized
    render nothing: true, status: :unauthorized
  end

  private

  def greenhouse_candidate_import_params
    params.fetch(:greenhouse_candidate_import)
  end
end
