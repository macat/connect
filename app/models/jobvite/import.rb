module Jobvite
  class Import
    attr_reader :status

    def initialize(
      connection,
      namely_connection:,
      jobvite_client: Jobvite::Client,
      namely_importer: NamelyImporter
    )
      @connection = connection
      @jobvite_client = jobvite_client
      @namely_importer = namely_importer
      @namely_connection = namely_connection
    end

    def import
      if connection.connected?
        import_recent_hires
      else
        set_status(:not_connected)
      end
    end

    private

    attr_reader :connection, :jobvite_client, :namely_importer, :namely_connection

    def import_recent_hires
      namely_importer.import(
        recent_hires: recent_hires,
        namely_connection: namely_connection,
        attribute_mapper: AttributeMapper.new,
      )
      set_status(:candidates_imported, count: recent_hires.length)
    rescue Jobvite::Client::Error => e
      set_status(:jobvite_error, message: e.message)
    end

    def recent_hires
      @recent_hires ||= jobvite_client.recent_hires(connection)
    end

    def set_status(key, options = {})
      @status = I18n.t(key, options.merge(scope: "jobvite_import.status"))
    end
  end
end
