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
        if invalid_request?
          raise_unauthorized_error_and_send_notification
        end
      else
        import = namely_importer.single_import(greenhouse_payload)
        if import.success?
          mailer.delay.successful_import(
            user,
            candidate_name.to_s
          )
        else
          mailer.delay.unsuccessful_import(user, candidate_name.to_s, import)
        end
      end
    end

    private

    def invalid_request?
      !Greenhouse::ValidRequesterPolicy.new(
        connection,
        signature,
        params
      ).valid?
    end

    def is_ping?
      greenhouse_payload.include? :web_hook_id
    end

    def connection
      @connection ||= connection_repo.find_by(secret_key: secret_key)
    end

    def greenhouse_payload
      params[:payload]
    end

    def raise_unauthorized_error_and_send_notification
      user.send_connection_notification("greenhouse")
      exception_class = Greenhouse::CandidatesImporter::Unauthorized
      error_message = "Invalid authentication for Greenhouse"

      Rails.logger.error(
        "#{exception_class} error #{error_message} for user_id: #{user.id}"
      )

      raise Unauthorized, error_message
    end

    def user
      connection.user
    end

    def namely_importer
      NamelyImporter.new(
        namely_connection: user.namely_connection,
        attribute_mapper: Greenhouse::AttributeMapper.new(
          user.namely_fields.all
        )
      )
    end

    attr_reader :candidate_name
  end
end
