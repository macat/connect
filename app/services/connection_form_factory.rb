class ConnectionFormFactory
  def self.create(connection:, integration_id:)
    new(connection: connection, integration_id: integration_id).create_instance
  end

  def initialize(connection:, integration_id:)
    @connection = connection
    @integration_id = integration_id
  end

  def create_instance
    connection_form_class.new(
      connection_form_class_arguments
    )
  end

  private

  def connection_form_class
    connection_form_class_mapping.fetch(@integration_id)
  end

  def connection_form_class_arguments
    arguments = {
      connection: @connection
    }

    if connection_form_class == NetSuite::ConnectionForm
      arguments[:client] = @connection.client
    end

    arguments
  end

  def connection_form_class_mapping
    {
      "greenhouse" => Greenhouse::ConnectionForm,
      "icims" => Icims::ConnectionForm,
      "jobvite" => Jobvite::ConnectionForm,
      "net_suite" => NetSuite::ConnectionForm
    }
  end
end
