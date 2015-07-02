module Icims
  class CandidateImporter
    INTEGRATION_ID = "icims"

    attr_reader :candidate, :imported_result, :params

    def initialize(connection, mailer, params)
      @connection = connection
      @mailer = mailer
      @params = params
    end

    def import
      @candidate = Icims::Client.new(connection).candidate(person_id)
      @imported_result = namely_importer.single_import(candidate)

      if imported_result.success?
        mailer.delay.successful_import(
          candidate: candidate,
          email: user.email,
          integration_id: INTEGRATION_ID
        )
      else
        mailer.delay.unsuccessful_import(
          candidate: candidate,
          email: user.email,
          integration_id: INTEGRATION_ID,
          status: imported_result
        )
      end
    rescue Icims::Client::Error => exception
      notifier.log_and_notify_of_unauthorized_exception(exception)
    end

    private

    def notifier
      AuthenticationNotifier.new(
        integration_id: INTEGRATION_ID,
        user: user
      )
    end

    def person_id
      params[:personId] || params[:id]
    end

    def customer_id
      params[:customerId]
    end

    def api_key
      params[:api_key]
    end

    def user
      @user ||= connection.user
    end

    def namely_importer
      NamelyImporter.new(
        attribute_mapper: Icims::AttributeMapper.new,
        namely_connection: user.namely_connection,
      )
    end

    def mailer
      @mailer
    end

    attr_reader :connection
  end
end
