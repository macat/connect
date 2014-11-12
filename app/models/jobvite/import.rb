module Jobvite
  class Import
    attr_reader :status

    def initialize(
      user,
      jobvite_client: Jobvite::Client,
      namely_importer: NamelyImporter
    )
      @user = user
      @jobvite_client = jobvite_client
      @namely_importer = namely_importer
    end

    def import
      if jobvite_connection.connected?
        import_recent_hires
      else
        set_status(:not_connected)
      end
    end

    private

    attr_reader :jobvite_client, :namely_importer, :user
    delegate :jobvite_connection, :namely_connection, to: :user

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
      @recent_hires ||= jobvite_client.recent_hires(jobvite_connection)
    end

    def set_status(key, options = {})
      @status = I18n.t(key, options.merge(scope: "jobvite_import.status"))
    end
  end
end
