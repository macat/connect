module Greenhouse
  CandidateName = Struct.new(:payload) do
    def to_s
      "#{candidate.fetch('first_name','')} #{candidate.fetch('last_name','')}".strip
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
