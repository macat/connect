module Greenhouse 
  class ValidRequesterPolicy
    def initialize(connection, signature, body) 
      @connection = connection
      @signature_algorithm, @signature = signature.split(/\s/)
      @body = body
    end

    def valid?
      build_signature == signature 
    end

    private 

    def digest
      @digest ||= OpenSSL::Digest.new(signature_algorithm.upcase)
    end

    def build_signature
      @build_signature = OpenSSL::HMAC.hexdigest(digest, 
                                                 connection.secret_key, 
                                                 body.to_json)
    end

    attr_reader :connection, :signature_algorithm, :signature, :body
  end
end
