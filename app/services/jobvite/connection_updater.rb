module Connect
  module Jobvite
    class ConnectionUpdater
      class UpdateFailed < StandardError; end

      def initialize(attributes, connection)
        @connection = connection
        @attributes = attributes
      end

      def update
        raise UpdateFailed.new unless connection.update(attributes)
        true
      end

      private

      attr_reader :connection, :attributes
    end
  end
end
