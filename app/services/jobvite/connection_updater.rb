module Connect
  module Jobvite
    class ConnectionUpdater
      def initialize(attributes, connection)
        @connection = connection
        @attributes = attributes
      end

      def update(success:,failure:)
        if connection.update(attributes)
          success.call
        else 
          failure.call
        end
      end

      private

      attr_reader :connection, :attributes
    end
  end
end
