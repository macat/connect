module Icims 
  class CandidateImporter
    attr_reader :candidate, :imported_result, :params

    class FailedImport < StandardError; end
    Params = Struct.new(:params) do 
      def customer_id
        params[:customerId]
      end

      def person_id
        params[:personId]
      end

      def api_key
        params[:api_key]
      end
    end

    def initialize(connection_repo, params)
      @connection_repo = connection_repo
      @params = Params.new(params)
    end

    def import
      @candidate = Icims::Client.new(connection).candidate(params.person_id)
      @imported_result = namely_importer.single_import(candidate)

      raise FailedImport.new unless imported_result.success?
    end

    def user
      connection.user
    end

    private 

    def connection 
      @connection_repo.find_by(api_key: params.api_key, 
                               customer_id: params.customer_id)
    end

    def namely_importer
      NamelyImporter.new(
        namely_connection: user.namely_connection,
        attribute_mapper: Icims::AttributeMapper.new,
      )
    end
  end
end
