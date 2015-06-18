class ConnectionFormFactory
  def self.create(connection:, form_type:)
    new(connection: connection, form_type: form_type).create_instance
  end

  def initialize(connection:, form_type:)
    @connection = connection
    @form_type = form_type
  end

  def create_instance
    connection_form_class.new(
      connection_form_class_arguments
    )
  end

  private

  def connection_form_class
    connection_form_class_mapping.fetch(@form_type)
  end

  def connection_form_class_arguments
    arguments = {
      connection: @connection
    }

    if connection_form_class == NetSuite::ConnectionForm
      arguments[:client] = net_suite_client
    end

    arguments
  end

  def connection_form_class_mapping
    {
      "greenhouse_connection" => Greenhouse::ConnectionForm,
      "icims_connection" => Icims::ConnectionForm,
      "jobvite_connection" => Jobvite::ConnectionForm,
      "net_suite_connection" => NetSuite::ConnectionForm
    }
  end

  def net_suite_client
    NetSuite::Client.new(
      user_secret: ENV.fetch("CLOUD_ELEMENTS_USER_SECRET"),
      organization_secret: ENV.fetch("CLOUD_ELEMENTS_ORGANIZATION_SECRET")
    )
  end
end
