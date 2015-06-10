module Greenhouse
  class CandidatesImporter
    attr_reader :mailer, :params, :signature, :secret_key, :connection_repo

    class Unauthorized < StandardError; end

    def initialize(mailer, connection_repo, params, secret_key, signature)
      @params = params
      @mailer = mailer
      @signature = signature
      @secret_key = secret_key
      @connection_repo = connection_repo
      @candidate_name = CandidateName.new(greenhouse_payload)
    end

    def import
      if is_ping?
        raise Unauthorized.new unless Greenhouse::ValidRequesterPolicy.new(
          connection,
          signature, params).valid?
      else
        import = namely_importer.single_import(greenhouse_payload)
        if import.success?
          mailer.delay.successful_import(
            user,
            candidate_name.to_s,
            identified_custom_fields)
        else
          mailer.delay.unsuccessful_import(user, candidate_name.to_s, import)
        end
      end
    end

    private

    def is_ping?
      greenhouse_payload.include? :web_hook_id
    end

    def connection
      @connection ||= connection_repo.find_by(secret_key: secret_key)
    end

    def greenhouse_payload
      params[:payload]
    end

    def user
      connection.user
    end

    def identified_custom_fields
      CustomFieldsIdentifier.new(greenhouse_payload).field_names
    end

    def namely_importer
      NamelyImporter.new(
        namely_connection: user.namely_connection,
        attribute_mapper: Greenhouse::AttributeMapper.new
      )
    end

    attr_reader :candidate_name
  end
end
