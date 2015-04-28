module Greenhouse 
  class ValidRequesterPolicy
    def initialize(connection, signature) 
      @connection = connection
      @signature_algorithm, @signature = signature.split(/\s/)
    end

    def valid?
      
    end

    private 

    def digest
      @digest ||= OpenSSL::Digest.new(signature_algorithm)
    end

    attr_reader :connection, :signature_algorithm, :signature
  end
end
