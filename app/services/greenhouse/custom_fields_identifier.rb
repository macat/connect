module Greenhouse
  class CustomFieldsIdentifier
    def self.identify(payload)
      new(payload).to_h
    end

    def initialize(payload)
      @payload = payload
    end

    def to_h
      custom_fields_for(candidate_node).merge(
        custom_fields_for(job_node)).merge(custom_fields_for(offer_node))
    end

    def field_names
      to_h.keys
    end

    private

    def application_node
      payload.fetch('application')
    end

    def candidate_node
      application_node.fetch('candidate')
    end

    def job_node
      application_node.fetch('job', {})
    end

    def offer_node
      application_node.fetch('offer', {})
    end

    def custom_fields_for(node)
      node.fetch('custom_fields', {}).inject({}) do |hash, kv|
        hash[kv[0].to_sym] = kv[1]['value']
        hash
      end
    end

    attr_reader :payload
  end
end
