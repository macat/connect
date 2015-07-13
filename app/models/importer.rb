class Importer
  def initialize(
    user:,
    client:,
    connection:,
    namely_importer:
  )

    @user = user
    @client = client
    @connection = connection
    @namely_importer = namely_importer
  end

  def import
    if connection.connected?
      import_recent_hires
    else
      FailedImport.new(error: I18n.t("status.not_connected"))
    end
  end

  private

  attr_reader :connection, :client, :namely_importer, :user
  delegate :namely_connection, to: :user

  def import_recent_hires
    namely_importer.import(recent_hires)
  rescue client.class::Error => e
    FailedImport.new(error: I18n.t("status.client_error", message: e.message))
  rescue Namely::FailedRequestError => e
    FailedImport.new(error:I18n.t("status.namely_error", message: e.message))
  end

  def recent_hires
    @recent_hires ||= client.recent_hires
  end
end
