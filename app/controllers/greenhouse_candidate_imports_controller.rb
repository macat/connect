class GreenhouseCandidateImportsController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token

  def create 
    if Greenhouse::ValidRequesterPolicy.new(connection).valid?(signature)
    end
  end

  private 

  def connection 
    @connection ||= Greenhouse::Connection.find_by(secret_key: secret_key)
  end

  def secret_key 
    @secret_key ||= params[:secret_key]
  end

  def signature 
    @signature ||= params['Signature']
  end
end
