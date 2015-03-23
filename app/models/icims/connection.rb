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
  end
end
