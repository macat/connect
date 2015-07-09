module Greenhouse
  class Authentication
    include ActiveModel::Model

    attr_accessor :name, :secret_key

    validates :name, presence: true

    def initialize(connection:)
      @connection = connection
      @secret_key = connection.secret_key
    end

    def allowed_parameters
      [:name, :secret_key]
    end

    def update(attributes)
      self.attributes = attributes
      valid? && @connection.update!(attributes)
    end

    private

    def attributes
      {
        name: name,
        secret_key: secret
      }
    end

    def attributes=(attributes)
      self.name = attributes[:name]
      self.secret_key = attributes[:secret_key]
    end
  end
end
