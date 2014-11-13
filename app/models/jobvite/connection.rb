module Jobvite
  class Connection < ActiveRecord::Base
    belongs_to :user

    validates :hired_workflow_state, presence: true

    def connected?
      api_key.present? && secret.present?
    end

    def disconnect
      update(
        api_key: nil,
        secret: nil
      )
    end

    def missing_namely_field?
      if connected?
        check_namely_field
        !found_namely_field?
      end
    end

    def required_namely_field
      AttributeMapper.new.namely_identifier_field.to_s
    end

    private

    delegate :namely_connection, to: :user

    def check_namely_field
      if !found_namely_field? && namely_account_has_required_field?
        update(found_namely_field: true)
      end
    end

    def namely_account_has_required_field?
      namely_connection.fields.all.detect do |field|
        field.name == required_namely_field
      end
    end
  end
end
