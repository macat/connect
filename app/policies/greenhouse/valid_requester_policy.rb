module Greenhouse 
  class ValidRequesterPolicy
    def initialize(connection, signature, body) 
      @connection = connection
      @signature_algorithm, @signature = signature.split(/\s/)
      @body = body
    end

    def valid?
      build_signature.include? signature 
    end

    private 

    def digest
      @digest ||= OpenSSL::Digest.new(signature_algorithm.upcase)
    end

    def build_signature
      @build_signature = OpenSSL::HMAC.digest(digest, connection.secret_key, 
                                                   payload).unpack('H*')
    end

    def payload
      body.fetch('payload').to_s
    end

    attr_reader :connection, :signature_algorithm, :signature, :body
  end
end
