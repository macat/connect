module Jobvite
  class ConnectionPresenter < SimpleDelegator
    include ActiveModel::Conversion

    def self.model_name
      Connection.model_name
    end

    def route_key
      self.class.model_name.singular_route_key
    end

    def readable_name
      "Jobvite"
    end

    def namespace
      :jobvite
    end

    def to_partial_path
      "dashboards/connection"
    end
  end
end
