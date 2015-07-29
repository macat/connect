module Jobvite
  class Connection < ActiveRecord::Base
    belongs_to :user

    validates :hired_workflow_state, presence: true

    def integration_id
      :jobvite
    end

    def connected?
      api_key.present? && secret.present?
    end

    def enabled?
      true
    end

    def ready?
      true
    end

    def attribute_mapper?
      false
    end

    def required_namely_field
      Jobvite::AttributeMapper.new.namely_identifier_field.to_s
    end

    def sync
      import_results.map { |result| Result.new(**result) }
    end

    private

    def import_results
      Importer.new(
        client: Jobvite::Client.new(self),
        connection: self,
        namely_importer: namely_importer,
        user: user,
      ).import
    end

    def namely_importer
      NamelyImporter.new(
        attribute_mapper: Jobvite::AttributeMapper.new,
        namely_connection: user.namely_connection,
      )
    end

    class Result
      def initialize(candidate:, result:)
        @candidate = candidate
        @result = result
      end

      delegate :name, to: :candidate
      delegate :success?, to: :result

      private

      attr_reader :candidate, :result
    end
    private_constant :Result
  end
end
