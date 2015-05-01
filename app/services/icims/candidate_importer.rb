module Icims
  class CandidateImporter
    attr_reader :candidate, :imported_result, :params

    def initialize(connection_repo, mailer, params)
      @connection_repo = connection_repo
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
      params[:personId]
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

    def connection
      @connection ||= @connection_repo.find_by(api_key: api_key,
                                               customer_id: customer_id)
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
  end
end
