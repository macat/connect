module Icims
  class ConnectionPresenter < SimpleDelegator
    include ActiveModel::Conversion

    def self.model_name
      Connection.model_name
    end

    def route_key
      self.class.model_name.singular_route_key
    end

    def readable_name
      "iCIMS"
    end

    def namespace
      :icims
    end

    def to_partial_path
      "icims_connections/connection"
    end
  end
end
