module Icims
  class Client
    class Error < StandardError
    end

    attr_reader :connection

    def self.recent_hires(connection)
      new(connection).recent_hires
    end

    def initialize(connection)
      @connection = connection
    end

    def recent_hires
      CandidateMapper.all(connection)
    end

    def candidate(person_id)
      Candidate.new(find_icims_candidate(person_id))
    end

    private

    def find_icims_candidate(person_id)
      CandidateFind.new(connection).find(person_id).merge("id" => person_id)
    end

    class CandidateMapper
      def self.all(connection)
        new(connection).candidates
      end

      def initialize(connection)
        @connection = connection
      end

      def candidates
        map_candidates
      rescue => e
        raise Error, e.message
      end

      private

      attr_reader :connection

      def all_candidates
        @all_candidate ||= CandidateSearch.new(connection: connection).all
      end

      def map_candidates
        all_candidates.fetch("searchResults", []).map do |hash|
          Candidate.new(candidate(hash["id"]).merge(hash))
        end
      end

      def candidate(id)
        CandidateFind.new(connection: connection).find(id)
      end
    end
    private_constant :CandidateMapper
  end
end
