module Jobvite
  class Authentication
    include ActiveModel::Model

    attr_accessor :api_key, :secret

    validates :api_key, presence: true
    validates :secret, presence: true

    def initialize(connection:)
      @connection = connection
    end

    def allowed_parameters
      [:api_key, :secret]
    end

    def update(attributes)
      self.attributes = attributes
      valid? && @connection.update!(attributes)
    end

    private

    def attributes
      {
        api_key: api_key,
        secret: secret
      }
    end

    def attributes=(attributes)
      self.api_key = attributes[:api_key]
      self.secret = attributes[:secret]
    end
  end
end
