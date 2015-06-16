module Icims
  class ConnectionForm
    include ActiveModel::Model

    attr_accessor :customer_id, :key, :username

    validates :customer_id, presence: true
    validates :key, presence: true
    validates :username, presence: true

    def initialize(connection:)
      @connection = connection
    end

    def update(attributes)
      self.attributes = attributes
      valid? && @connection.update!(attributes)
    end

    private

    def attributes
      {
        customer_id: customer_id,
        key: key,
        username: username
      }
    end

    def attributes=(attributes)
      self.customer_id = attributes[:customer_id]
      self.key = attributes[:key]
      self.username = attributes[:username]
    end
  end
end
