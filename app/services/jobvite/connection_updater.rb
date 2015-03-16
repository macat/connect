module Connect
  module Jobvite
    class ConnectionUpdater
      include Wisper::Publisher

      def initialize(connection)
        @connection = connection
      end

      def update(attributes)
        if connection.update(attributes)
          broadcast :connection_updated_successfully
        else 
          broadcast :connection_updated_unsuccessfully
        end
      end

      private

      attr_reader :connection
    end
  end
end
