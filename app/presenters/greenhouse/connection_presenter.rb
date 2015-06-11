module Greenhouse
  class ConnectionPresenter < SimpleDelegator
    include ActiveModel::Conversion

    def self.model_name
      Connection.model_name
    end

    def route_key
      self.class.model_name.singular_route_key
    end

    def readable_name
      "Greenhouse"
    end

    def namespace
      :greenhouse
    end

    def to_partial_path
      "greenhouse_connections/connection"
    end
  end
end
