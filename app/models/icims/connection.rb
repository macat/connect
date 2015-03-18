require "base64"

module Icims
  class Connection < ActiveRecord::Base
    belongs_to :user

    def connected?
      username.present? && key.present? && customer_id.present?
    end

    def api_url
      "https://api.icims.com/customers/#{customer_id}"
    end

    def disconnect
      update(
        customer_id: nil,
        key: nil,
        username: nil,
      )
    end

    def missing_namely_field?
      if connected?
        check_namely_field
      end
    end

    def required_namely_field
      AttributeMapper.new.namely_identifier_field.to_s
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
