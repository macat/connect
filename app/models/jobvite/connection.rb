module Jobvite
  class Connection < ActiveRecord::Base
    belongs_to(
      :attribute_mapper,
      dependent: :destroy,
      class_name: "::AttributeMapper"
    )
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
      true
    end

    def attribute_mapper
      AttributeMapperFactory.new(attribute_mapper: super, connection: self).
        build_with_defaults(
          "first_name" => "first_name",
          "last_name" => "last_name",
          "email" => "email",
          "start_date" => "start_date",
          "gender" => "gender",
        )
    end

    def required_namely_field
      jobvite_attribute_mapper.namely_identifier_field.to_s
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
        attribute_mapper: jobvite_attribute_mapper,
        namely_connection: user.namely_connection,
      )
    end

    def jobvite_attribute_mapper
      Jobvite::AttributeMapper.new(
        attribute_mapper: attribute_mapper
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
