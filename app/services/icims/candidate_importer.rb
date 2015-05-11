module Icims
  class CandidateImporter
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
        mailer.delay.successful_import(user, candidate)
      else
        mailer.delay.unsuccessful_import(user, candidate, imported_result)
      end
    rescue Icims::Client::Error => e
      mailer.delay.unauthorized_import(user, e.message)
    end

    private

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
        namely_connection: user.namely_connection,
        attribute_mapper: Icims::AttributeMapper.new,
      )
    end

    def mailer
      @mailer
    end

    attr_reader :connection
  end
end
