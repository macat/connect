class GreenhouseCandidateImportsController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token

  def create 
    if is_ping? 
      if Greenhouse::ValidRequesterPolicy.new(connection, 
                                              signature, params).valid?
        render text: nil, status: :ok 
      end
    else 
      namely_importer.single_import(greenhouse_payload)
      render text: nil, status: :ok
    end
  end

  private 

  def namely_importer 
    NamelyImporter.new(
      namely_connection: user.namely_connection,
      attribute_mapper: Greenhouse::AttributeMapper.new
    )
  end

  def connection 
    @connection ||= Greenhouse::Connection.find_by(secret_key: secret_key)
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

  def greenhouse_payload
    params['payload']
  end

  def is_ping?
    greenhouse_payload.include? 'web_hook_id'
  end
end
