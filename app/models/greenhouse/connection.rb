module Greenhouse
  class Connection < ActiveRecord::Base
    belongs_to :user

    def connected?
      token.present?
    end

    def missing_namely_field?
      if connected?
        check_namely_field
      end
    end

    def required_namely_field
      "greenhouse_id"
    end

    private 

    delegate :namely_connection, to: :user

    def check_namely_field
      if namely_field_not_found? && namely_account_has_required_field?
        update(found_namely_field: true)
      end
      namely_field_not_found?
    end

    def namely_field_not_found?
      !found_namely_field?
    end

    def namely_account_has_required_field?
      namely_connection.fields.all.detect do |field|
        field.name == required_namely_field
      end
    end
  end
end
