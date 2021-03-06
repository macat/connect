module Icims
  class Connection < ActiveRecord::Base
    belongs_to :user
    validates :user_id, presence: true
    validates :api_key, uniqueness: true
    before_create :set_api_key

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
        UserCheckNamelyField.new(self).check?
      end
    end

    def required_namely_field
      AttributeMapper.new.namely_identifier_field.to_s
    end

    def set_api_key
      self.api_key = SecureRandom.hex(20)
    end
  end
end
