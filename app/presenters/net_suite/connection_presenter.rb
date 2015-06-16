module NetSuite
  class ConnectionPresenter < SimpleDelegator
    include ActiveModel::Conversion

    def self.model_name
      Connection.model_name
    end

    def route_key
      self.class.model_name.singular_route_key
    end

    def readable_name
      "NetSuite"
    end

    def namespace
      :net_suite
    end

    def to_partial_path
      "net_suite_connections/connection"
    end
  end
end
