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
        UserCheckNamelyField.new(self).check?
      end
    end

    def required_namely_field
      AttributeMapper.new.namely_identifier_field.to_s
    end
  end
end
