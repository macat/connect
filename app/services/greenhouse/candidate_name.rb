module Greenhouse
  class CandidateName < Struct.new(:payload)
    def name
      "#{candidate.fetch('first_name', '')} " \
      "#{candidate.fetch('last_name', '')}".strip
    end

    def to_s
      name
    end

    private

    def application
      @application ||= payload.fetch('application')
    end

    def candidate
      @candidate ||= application.fetch('candidate')
    end
  end
end
