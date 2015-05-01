class GreenhouseCandidateImportsController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token

  def create
    if is_ping?
      if Greenhouse::ValidRequesterPolicy.new(connection,
                                              signature, 
                                              greenhouse_candidate_import_params).valid?
        status = :ok
      else
        status = :unauthorized
      end
    else
      import = namely_importer.single_import(greenhouse_payload)
      if import.success?
        mailer.delay.successful_import(user, candidate_name)
        status = :ok
      end
    end
    render text: nil, status: status
  end

  private

  def mailer
    GreenhouseCandidateImportMailer
  end

  def namely_importer
    NamelyImporter.new(
      namely_connection: user.namely_connection,
      attribute_mapper: Greenhouse::AttributeMapper.new
    )
  end

  def connection
    @connection ||= Greenhouse::Connection.find_by(secret_key: secret_key)
  end

  def candidate_name
    candidate = greenhouse_payload.fetch('application').fetch('candidate')
    @candidate_name ||= "#{candidate.fetch('first_name')} #{candidate.fetch('last_name')}"
  end

  def user
    connection.user
  end

  def secret_key
    @secret_key ||= params['secret_key']
  end

  def signature
    @signature ||= request.headers['Signature']
  end

  def greenhouse_candidate_import_params
    params.fetch(:greenhouse_candidate_import)
  end

  def greenhouse_payload
    greenhouse_candidate_import_params[:payload]
  end

  def is_ping?
    greenhouse_payload.include? 'web_hook_id'
  end
end
