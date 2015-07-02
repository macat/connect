module Greenhouse
  class CandidatesImporter
    INTEGRATION_ID = "greenhouse"

    attr_reader(
      :connection_repo,
      :mailer,
      :params,
      :secret_key,
      :signature,
    )

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
            candidate: candidate_name,
            email: user.email,
            integration_id: INTEGRATION_ID
          )
        else
          mailer.delay.unsuccessful_import(
            candidate: candidate_name,
            email: user.email,
            integration_id: INTEGRATION_ID,
            status: import
          )
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
      exception = Unauthorized.new(Unauthorized::DEFAULT_MESSAGE)
      notifier.log_and_notify_of_unauthorized_exception(exception)

      raise exception
    end

    def notifier
      AuthenticationNotifier.new(
        integration_id: INTEGRATION_ID,
        user: user
      )
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
